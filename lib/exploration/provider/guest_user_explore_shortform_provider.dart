import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/model/explore_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/repository/guest_user_explore_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

final guestUserExploreShortFormProvider = StateNotifierProvider.autoDispose<
    GuestUserExploreShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final exploreShortFormRepository =
        ref.watch(guestUserExploreShortFormRepositoryProvider);
    final category = ref.watch(explorationCategoryProvider);

    return GuestUserExploreShortFormStateNotifier(
      exploreShortFormRepository,
      additionalParams: ExploreShortFormAdditionalParams(
        category: category,
      ),
    );
  },
);

class GuestUserExploreShortFormStateNotifier extends CursorPaginationProvider<
    ShortFormModel, GuestUserExploreShortFormRepository> {
  GuestUserExploreShortFormStateNotifier(
    super.repository, {
    super.additionalParams,
  });
}
