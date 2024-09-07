import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/post_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_like_button_animation_trigger_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/repository/logged_in_user_shortform_comment_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/post_shortform_reply_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/put_shortform_reply_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/shortform_reply_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/repository/logged_in_user_shortform_reply_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_blocked_user_list_provider.dart';

final loggedInUserShortFormReplyProvider = StateNotifierProvider.family
    .autoDispose<LoggedInUserShortFormReplyStateNotifier, CursorPaginationBase,
        int>(
  (ref, parentCommentId) {
    final shortFormReplyRepository =
        ref.watch(loggedInUserShortFormReplyRepositoryProvider);

    return LoggedInUserShortFormReplyStateNotifier(
      shortFormReplyRepository,
      ref: ref,
      parentCommentId: parentCommentId,
      additionalParams:
          ShortFormReplyAdditionalParams(commentId: parentCommentId),
    );
  },
);

class LoggedInUserShortFormReplyStateNotifier extends CursorPaginationProvider<
    ShortFormCommentModel, LoggedInUserShortFormReplyRepository> {
  final Ref ref;
  final int parentCommentId;

  LoggedInUserShortFormReplyStateNotifier(
    super.repository, {
    required this.ref,
    required this.parentCommentId,
    super.additionalParams,
  });

  Future<({bool success, String? errorCode, String? errorMessage})> postReply({
    required int newsId,
    required String content,
  }) async {
    // 대댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(replyId: null);

    if (prevState == null) {
      return (
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '댓글 작성에 실패했습니다.',
      );
    }

    // _getValidPrevState를 통해 적절한 값을 가져왔다면 유저의 상태가 UserModel임이 보장됨
    final userInfo = ref.read(userInfoProvider) as UserModel;

    // 대댓글 작성 요청
    final resp = await repository.postReply(
      body: PostShortFormReplyBody(
        newsId: newsId,
        commentId: parentCommentId,
        content: content,
      ),
    );
    // 작성된 대댓글 정보
    final replyInfo = resp.data;

    // success값이 true가 아니거나 작성된 대댓글 정보가 없는 경우 실패 처리
    if (resp.success != true || replyInfo == null) {
      return (
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '댓글 작성에 실패했습니다.'
      );
    }

    // 기존 데이터 마지막에 새로운 데이터 추가
    // 마지막 페이지인 경우에만 추가
    // 마지막 페이지가 아닌 경우, 페이지네이션을 하면서 추가되기 때문에 추가하지 않음
    if (prevState.pageInfo.isLast) {
      prevState.items.add(
        ShortFormCommentModel(
          user: ShortFormCommentUserInfo(
            id: userInfo.id,
            nickname: userInfo.nickname,
            profileImg: userInfo.profileImg,
          ),
          comment: ShortFormCommentInfo(
            id: replyInfo.id,
            userId: replyInfo.userId,
            newsId: replyInfo.newsId,
            content: replyInfo.content,
            editedAt: replyInfo.editedAt,
          ),
          commentLikeCnt: 0,
          replyCnt: 0,
          userLike: false,
        ),
      );

      // 새 상태 반영
      state = prevState.copyWith();
    }

    // 대댓글이 추가된 경우 댓글창에 보여지는 replyCnt를 1개 증가시킴
    // 마지막 페이지가 아닌 경우에만 증가시킴
    // 마지막 페이지인 경우 다른 로직에 의해 증가됨
    if (!prevState.pageInfo.isLast) {
      ref
          .read(loggedInUserShortFormCommentProvider(newsId).notifier)
          .setReplyCntByDelta(commentId: parentCommentId, delta: 1);
    }

    return (success: true, errorCode: null, errorMessage: null);
  }

  Future<bool> updateReply({
    required int replyId,
    required String content,
    required int index,
  }) async {
    // 대댓글 수정 전 상태를 저장
    final prevState = _getValidPrevState(replyId: replyId);

    if (prevState == null) {
      return false;
    }

    // 대댓글 수정 요청
    final resp = await repository.updateReply(
      body: PutShortFormReplyBody(
        replyId: replyId,
        content: content,
      ),
    );
    // 수정된 대댓글 내용
    final updatedContent = resp.data;

    // success값이 true가 아니거나 수정된 댓글 내용이 없는 경우 실패 처리
    if (resp.success != true || updatedContent == null) {
      return false;
    }

    // 기존 대댓글 내용을 수정된 내용으로 변경
    try {
      prevState.items[index] = prevState.items[index].copyWith(
        comment:
            prevState.items[index].comment.copyWith(content: updatedContent),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    state = prevState.copyWith();

    return true;
  }

  Future<bool> deleteReply({
    required int newsId,
    required int replyId,
    required int index,
  }) async {
    // 대댓글 삭제 전 상태를 저장
    final prevState = _getValidPrevState(replyId: replyId);

    if (prevState == null) {
      return false;
    }

    // 대댓글 삭제 요청
    final resp = await repository.deleteReply(replyId: replyId);

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    // 대댓글 삭제
    try {
      prevState.items.removeAt(index);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    state = prevState.copyWith();

    // 대댓글이 삭제된 경우 댓글창에 보여지는 replyCnt를 1개 감소시킴
    // 마지막 페이지가 아닌 경우에만 감소시킴
    // 마지막 페이지인 경우 다른 로직에 의해 감소됨
    if (!prevState.pageInfo.isLast) {
      ref
          .read(loggedInUserShortFormCommentProvider(newsId).notifier)
          .setReplyCntByDelta(commentId: parentCommentId, delta: -1);
    }

    return true;
  }

  Future<bool> toggleCommentLike({
    required int replyId,
    required int index,
  }) async {
    final prevState = _getValidPrevState(replyId: replyId);

    if (prevState == null) {
      return false;
    }

    // 이전 상태의 좋아요 상태
    final prevLike = prevState.items[index].userLike;

    // 서버 요청 전 미리 상태 변경
    prevState.items[index] = prevState.items[index].copyWith(
      userLike: !prevLike,
      commentLikeCnt:
          prevState.items[index].commentLikeCnt + (prevLike ? -1 : 1),
    );

    // 변경된 상태 적용
    state = prevState.copyWith();

    // 좋아요를 누른 경우
    if (!prevLike) {
      // 좋아요 애니메이션 트리거
      ref
          .read(shortFormLikeButtonAnimationTriggerProvider(replyId).notifier)
          .state = true;

      // 서버에 좋아요 요청
      final resp = await ref
          .read(loggedInUserShortFormCommentRepositoryProvider)
          .postCommentLike(
            body: PostShortFormCommentLikeBody(commentId: replyId),
          );

      // success값이 true가 아니면 실패 처리
      if (resp.success != true) {
        return false;
      }

      return true;
    }

    // 좋아요를 취소한 경우
    // 좋아요 애니메이션 트리거 해제
    ref
        .read(shortFormLikeButtonAnimationTriggerProvider(replyId).notifier)
        .state = false;

    // 서버에 좋아요 취소 요청
    final resp = await ref
        .read(loggedInUserShortFormCommentRepositoryProvider)
        .deleteCommentLike(commentId: replyId);

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    return true;
  }

  Future<bool> hideUserAndComment({
    required int newsId,
    required int userId,
  }) async {
    // 댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(replyId: null);

    if (prevState == null) {
      return false;
    }

    // 유저 차단 요청
    final hidedUserIdResp = await ref
        .read(loggedInUserBlockedUserListProvider.notifier)
        .hideUser(userId);

    // 결과 값이 null 이면 실패 처리
    if (hidedUserIdResp == null) {
      return false;
    }

    // 차단된 유저 댓글 숨김
    state = prevState.copyWith(
      items: prevState.items
          .where((element) => element.user.id != hidedUserIdResp)
          .toList(),
    );

    // 대댓글창 뿐만 아니라 댓글창에서도 차단된 유저의 댓글을 숨김
    ref
        .read(loggedInUserShortFormCommentProvider(newsId).notifier)
        .setStateBlockedUserComment(hidedUserIdResp);

    return true;
  }

  // 대댓글 관련 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<ShortFormCommentModel>? _getValidPrevState({
    required int? replyId,
  }) =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이며
      // 대댓글 ID가 알 수 없는 값이 아닌 경우 유효한 상태로 간주
      // replyId가 null인 경우는 replyId가 필요 없는 요청인 경우
      state is CursorPagination<ShortFormCommentModel> &&
              ref.read(userInfoProvider) is UserModel &&
              (replyId == null || replyId != Constants.unknownErrorId)
          ? state as CursorPagination<ShortFormCommentModel>
          : null;
}
