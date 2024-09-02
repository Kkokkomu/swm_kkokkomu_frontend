import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/post_shortform_comment_body.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_sort_type_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/repository/logged_in_user_shortform_comment_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

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
      apiPath: '/${shortFormCommentSortType.name}',
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

  Future<bool> postComment(String content) async {
    // 댓글 작성 전 상태를 저장
    final prevState = state;
    final userInfo = ref.read(userInfoProvider);

    // 이전 상태가 CursorPagination이 아닌 경우, 즉, 댓글이 정상적으로 로드되지 않은 경우
    // 또는 유저 정보가 UserModel이 아닌 경우, 즉, 로그인이 되어있지 않은 경우
    // 부적절한 상태로 댓글 작성을 시도한 것으로 간주
    // 댓글 작성을 실패 처리
    if (prevState is! CursorPagination<ShortFormCommentModel> ||
        userInfo is! UserModel) {
      return false;
    }

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
      return false;
    }

    // 기존 데이터에
    // 새로운 댓글 데이터 추가
    state = prevState.copyWith(items: [
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
      ...prevState.items,
    ]);

    return true;
  }
}
