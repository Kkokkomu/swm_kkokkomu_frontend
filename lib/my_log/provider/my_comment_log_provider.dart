import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_comment_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/repository/my_comment_log_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/provider/logged_in_user_shortform_reply_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final myCommentLogProvider = StateNotifierProvider.autoDispose<
    MyCommentLogStateNotifier, CursorPaginationBase>(
  (ref) {
    final myCommentLogRepository = ref.watch(myCommentLogRepositoryProvider);

    return MyCommentLogStateNotifier(
      myCommentLogRepository,
      '',
      ref: ref,
    );
  },
);

class MyCommentLogStateNotifier extends CursorPaginationProvider<
    MyCommentLogModel, MyCommentLogRepository> {
  final Ref ref;

  MyCommentLogStateNotifier(
    super.repository,
    super.apiPath, {
    required this.ref,
  });

  // 내 댓글 화면에서 댓글 삭제
  Future<bool> deleteComment({
    required int commentId,
    required int newsId,
  }) async {
    // 댓글 삭제 전 상태를 저장
    final prevState = _getValidPrevState(commentOrReplyId: commentId);

    if (prevState == null) {
      return false;
    }

    // 숏폼 화면에서 해당 뉴스의 댓글 창이 활성화 되어있는 경우
    // 해당 뉴스의 댓글 창에서 댓글 삭제 요청
    if (ref.exists(loggedInUserShortFormCommentProvider(newsId))) {
      return await ref
          .read(loggedInUserShortFormCommentProvider(newsId).notifier)
          .deleteCommentById(commentId);
    }

    // 숏폼 화면에서 해당 뉴스의 댓글 창이 활성화 되어있지 않은 경우
    // 내 댓글 화면에서만 댓글 삭제 요청
    // 댓글 삭제 요청
    final resp = await repository.deleteComment(commentId: commentId);

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    // 댓글 삭제
    // 댓글 삭제 시, 해당 댓글의 대댓글도 함께 삭제
    prevState.items.removeWhere(
      (element) =>
          (element.id == commentId || element.comment.parentId == commentId),
    );

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 내 댓글 화면에서 대댓글 삭제
  Future<bool> deleteReply({
    required int parentCommentId,
    required int replyId,
    required int index,
    required int newsId,
  }) async {
    // 대댓글 삭제 전 상태를 저장
    final prevState = _getValidPrevState(commentOrReplyId: replyId);

    if (prevState == null) {
      return false;
    }

    // 숏폼 화면에서 해당 뉴스의 대댓글 창이 활성화 되어있는 경우
    // 해당 뉴스의 대댓글 창에서 댓글 삭제 요청
    if (ref.exists(loggedInUserShortFormReplyProvider(parentCommentId))) {
      return await ref
          .read(loggedInUserShortFormReplyProvider(parentCommentId).notifier)
          .deleteReplyById(
            newsId: newsId,
            replyId: replyId,
          );
    }

    // 숏폼 화면에서 해당 뉴스의 대댓글 창이 활성화 되어있지 않은 경우
    // 내 댓글 화면에서만 대댓글 삭제 요청
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

    // 숏폼 화면의 댓글창이 활성화 된 상태라면
    // 댓글창에 보여지는 replyCnt를 1개 감소시킴
    if (ref.exists(loggedInUserShortFormCommentProvider(newsId))) {
      ref
          .read(loggedInUserShortFormCommentProvider(newsId).notifier)
          .setReplyCntByDelta(commentId: parentCommentId, delta: -1);
    }

    state = prevState.copyWith();

    return true;
  }

  // 숏폼 화면 댓글창에서 삭제한 댓글을 내 댓글 로그 화면에서도 삭제 처리
  bool updateDeletedCommentState(int commentId) {
    // 댓글 삭제 전 상태를 저장
    final prevState = _getValidPrevState(commentOrReplyId: commentId);

    if (prevState == null) {
      return false;
    }

    // 댓글 삭제
    // 댓글 삭제 시, 해당 댓글의 대댓글도 함께 삭제
    prevState.items.removeWhere(
      (element) =>
          (element.id == commentId || element.comment.parentId == commentId),
    );

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 숏폼 화면 대댓글창에서 삭제한 대댓글을 내 댓글 로그 화면에서도 삭제 처리
  bool updateDeletedReplyState(int replyId) {
    // 대댓글 삭제 전 상태를 저장
    final prevState = _getValidPrevState(commentOrReplyId: replyId);

    if (prevState == null) {
      return false;
    }

    // 대댓글 삭제
    prevState.items.removeWhere((element) => element.id == replyId);

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 숏폼 화면 댓글/대댓글창에서 수정한 댓글/대댓글을 내 댓글 로그 화면에서도 수정 처리
  bool updateEditedCommentOrReplyState({
    required int commentOrReplyId,
    required String editedContent,
  }) {
    // 댓글 수정 전 상태를 저장
    final prevState = _getValidPrevState(commentOrReplyId: commentOrReplyId);

    if (prevState == null) {
      return false;
    }

    final indexForEdit =
        prevState.items.indexWhere((element) => element.id == commentOrReplyId);

    if (indexForEdit == -1) {
      return false;
    }

    // 댓글/대댓글 수정
    prevState.items[indexForEdit] = prevState.items[indexForEdit].copyWith(
      comment: prevState.items[indexForEdit].comment.copyWith(
        content: editedContent,
      ),
    );

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 숏폼 화면 댓글/대댓글창에서 추가한 댓글/대댓글을 내 댓글 로그 화면에서도 추가 처리
  bool updateAddedCommentOrReplyState(MyCommentLogModel addedCommentOrReply) {
    // 댓글 작성 전 상태를 저장
    final prevState =
        _getValidPrevState(commentOrReplyId: addedCommentOrReply.id);

    if (prevState == null) {
      return false;
    }

    // 댓글 추가
    prevState.items.insert(0, addedCommentOrReply);

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<MyCommentLogModel>? _getValidPrevState({
    required int commentOrReplyId,
  }) =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이며
      // commentOrReplyId가 unknownErrorId가 아닌 경우
      // 유효한 상태로 간주
      state is CursorPagination<MyCommentLogModel> &&
              ref.read(userInfoProvider) is UserModel &&
              commentOrReplyId != Constants.unknownErrorId
          ? state as CursorPagination<MyCommentLogModel>
          : null;
}
