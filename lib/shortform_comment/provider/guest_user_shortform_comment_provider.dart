import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_sort_type_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/repository/guest_user_shortform_comment_repository.dart';

final guestUserShortFormCommentProvider = StateNotifierProvider.family
    .autoDispose<GuestUserShortFormCommentStateNotifier, CursorPaginationBase,
        int>(
  (ref, newsId) {
    final shortFormCommentRepository =
        ref.watch(guestUserShortFormCommentRepositoryProvider);
    final shortFormCommentSortType =
        ref.watch(shortFormCommentSortTypeProvider(newsId));

    return GuestUserShortFormCommentStateNotifier(
      shortFormCommentRepository,
      '/${shortFormCommentSortType.name}/guest',
      additionalParams: ShortFormCommentAdditionalParams(newsId: newsId),
    );
  },
);

class GuestUserShortFormCommentStateNotifier extends CursorPaginationProvider<
    ShortFormCommentModel, GuestUserShortFormCommentRepository> {
  GuestUserShortFormCommentStateNotifier(
    super.repository,
    super.apiPath, {
    super.additionalParams,
  });

  // 대댓글창에서 대댓글 개수 변화될 때 댓글창에 보여지는 replyCnt 수에 반영함
  void setReplyCnt({
    required int commentId,
    required int cnt,
  }) {
    // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고
    // 댓글 ID가 알 수 없는 값이 아닌 경우 유효한 상태로 간주
    final prevState = state is CursorPagination<ShortFormCommentModel> &&
            commentId != Constants.unknownErrorId
        ? state as CursorPagination<ShortFormCommentModel>
        : null;

    if (prevState == null) {
      return;
    }

    final index =
        prevState.items.indexWhere((element) => element.id == commentId);

    // 댓글 ID가 존재하지 않는 경우 무시
    if (index == -1) {
      return;
    }

    // replyCnt가 변경되지 않은 경우 무시
    if (prevState.items[index].replyCnt == cnt) {
      return;
    }

    // 댓글 ID가 존재하는 경우 해당 댓글의 대댓글 수 조정
    prevState.items[index] = prevState.items[index].copyWith(replyCnt: cnt);

    state = prevState.copyWith();
  }
}
