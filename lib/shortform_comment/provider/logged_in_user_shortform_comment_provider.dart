import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/post_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/put_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_report_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_sort_type_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_like_button_animation_trigger_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/repository/logged_in_user_shortform_comment_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_blocked_user_list_provider.dart';

final loggedInUserShortFormCommentProvider = StateNotifierProvider.family
    .autoDispose<LoggedInUserShortFormCommentStateNotifier,
        CursorPaginationBase, int>(
  (ref, newsId) {
    final shortFormCommentRepository =
        ref.watch(loggedInUserShortFormCommentRepositoryProvider);
    final shortFormCommentSortType =
        ref.watch(shortFormCommentSortTypeProvider(newsId));

    return LoggedInUserShortFormCommentStateNotifier(
      shortFormCommentRepository,
      ref: ref,
      newsId: newsId,
      additionalParams: ShortFormCommentAdditionalParams(newsId: newsId),
      apiPath: shortFormCommentSortType.name,
    );
  },
);

class LoggedInUserShortFormCommentStateNotifier
    extends CursorPaginationProvider<ShortFormCommentModel,
        LoggedInUserShortFormCommentRepository> {
  final Ref ref;
  final int newsId;

  LoggedInUserShortFormCommentStateNotifier(
    super.repository, {
    required this.ref,
    required this.newsId,
    super.additionalParams,
    super.apiPath,
  });

  Future<({bool success, String? errorCode, String? errorMessage})> postComment(
      String content) async {
    // 댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(commentId: null);

    if (prevState == null) {
      return (
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '댓글 작성에 실패했습니다.'
      );
    }

    // _getValidPrevState를 통해 적절한 값을 가져왔다면 유저의 상태가 UserModel임이 보장됨
    final userInfo = ref.read(userInfoProvider) as UserModel;

    // 댓글 작성 요청
    final resp = await repository.postComment(
      body: PostShortFormCommentBody(
        newsId: newsId,
        content: content,
      ),
    );
    // 작성된 댓글 정보
    final commentInfo = resp.data;

    // success값이 true가 아니거나 작성된 댓글 정보가 없는 경우 실패 처리
    if (resp.success != true || commentInfo == null) {
      return (
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '댓글 작성에 실패했습니다.'
      );
    }

    // 기존 데이터에
    // 새로운 댓글 데이터 추가
    prevState.items.insert(
      0,
      ShortFormCommentModel(
        user: ShortFormCommentUserInfo(
          id: userInfo.id,
          nickname: userInfo.nickname,
          profileImg: userInfo.profileImg,
        ),
        comment: commentInfo,
        commentLikeCnt: 0,
        replyCnt: 0,
        userLike: false,
      ),
    );

    state = prevState.copyWith();

    return (success: true, errorCode: null, errorMessage: null);
  }

  Future<bool> updateComment({
    required int commentId,
    required String content,
    required int index,
  }) async {
    // 댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(commentId: commentId);

    if (prevState == null) {
      return false;
    }

    // 댓글 수정 요청
    final resp = await repository.updateComment(
      body: PutShortFormCommentBody(
        commentId: commentId,
        content: content,
      ),
    );
    // 수정된 댓글 내용
    final updatedContent = resp.data;

    // success값이 true가 아니거나 수정된 댓글 내용이 없는 경우 실패 처리
    if (resp.success != true || updatedContent == null) {
      return false;
    }

    // 기존 댓글 내용을 수정된 내용으로 변경
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

  Future<bool> deleteComment({
    required int commentId,
    required int index,
  }) async {
    // 댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(commentId: commentId);

    if (prevState == null) {
      return false;
    }

    // 댓글 수정 요청
    final resp = await repository.deleteComment(commentId: commentId);

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    // 댓글 삭제
    try {
      prevState.items.removeAt(index);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    state = prevState.copyWith();

    return true;
  }

  Future<bool> toggleCommentLike({
    required int commentId,
    required int index,
  }) async {
    final prevState = _getValidPrevState(commentId: commentId);

    if (prevState == null) {
      return false;
    }

    final prevLike = prevState.items[index].userLike;

    prevState.items[index] = prevState.items[index].copyWith(
      userLike: !prevLike,
      commentLikeCnt:
          prevState.items[index].commentLikeCnt + (prevLike ? -1 : 1),
    );

    state = prevState.copyWith();

    // 좋아요를 누른 경우
    if (!prevLike) {
      // 좋아요 애니메이션 트리거
      ref
          .read(shortFormLikeButtonAnimationTriggerProvider(commentId).notifier)
          .state = true;

      // 서버에 좋아요 요청
      final resp = await repository.postCommentLike(
        body: PostShortFormCommentLikeBody(commentId: commentId),
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
        .read(shortFormLikeButtonAnimationTriggerProvider(commentId).notifier)
        .state = false;

    // 서버에 좋아요 취소 요청
    final resp = await repository.deleteCommentLike(commentId: commentId);

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    return true;
  }

  Future<bool> hideUserAndComment({
    required int userId,
  }) async {
    // 댓글 작성 전 상태를 저장
    final prevState = _getValidPrevState(commentId: null);

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

    return true;
  }

  Future<bool> reportComment({
    required int commentId,
    required CommentReportType reason,
  }) async {
    // 로그인된 유저가 아닌 경우 실패 처리
    if (ref.read(userInfoProvider) is! UserModel) {
      return false;
    }

    // 댓글 신고 요청
    final resp = await repository.reportComment(
      body: PostCommentReportModel(
        reason: reason,
        commentId: commentId,
      ),
    );

    // success값이 true가 아니거나 신고된 댓글 정보가 없는 경우 실패 처리
    if (resp.success != true || resp.data == null) {
      return false;
    }

    return true;
  }

  // 대댓글에서 차단한 유저를 댓글에서도 숨김 처리
  void setStateBlockedUserComment(int userId) {
    final prevState = _getValidPrevState(commentId: null);

    if (prevState == null) {
      return;
    }

    state = prevState.copyWith(
      items: prevState.items
          .where((element) => element.user.id != userId)
          .toList(),
    );
  }

  // 대댓글창에서 대댓글 개수 변화될 때 댓글창에 보여지는 replyCnt 수에 반영함
  void adjustReplyCnt({
    required int commentId,
    required int delta,
  }) {
    final prevState = _getValidPrevState(commentId: commentId);

    if (prevState == null) {
      return;
    }

    final index =
        prevState.items.indexWhere((element) => element.id == commentId);

    // 댓글 ID가 존재하지 않는 경우 무시
    if (index == -1) {
      return;
    }

    // 댓글 ID가 존재하는 경우 해당 댓글의 대댓글 수 조정
    prevState.items[index] = prevState.items[index]
        .copyWith(replyCnt: prevState.items[index].replyCnt + delta);

    state = prevState.copyWith();
  }

  // 댓글 관련 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<ShortFormCommentModel>? _getValidPrevState({
    required int? commentId,
  }) =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이며
      // 댓글 ID가 알 수 없는 값이 아닌 경우 유효한 상태로 간주
      // commentId가 null인 경우는 commentId가 필요 없는 요청인 경우
      state is CursorPagination<ShortFormCommentModel> &&
              ref.read(userInfoProvider) is UserModel &&
              (commentId == null || commentId != Constants.unknownErrorId)
          ? state as CursorPagination<ShortFormCommentModel>
          : null;
}
