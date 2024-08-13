import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      additionalParams: ShortFormCommentAdditionalParams(newsId: newsId),
      apiPath: '/${shortFormCommentSortType.name}/guest',
    );
  },
);

class GuestUserShortFormCommentStateNotifier extends CursorPaginationProvider<
    ShortFormCommentModel, GuestUserShortFormCommentRepository> {
  GuestUserShortFormCommentStateNotifier(
    super.repository, {
    super.additionalParams,
    super.apiPath,
  });
}
