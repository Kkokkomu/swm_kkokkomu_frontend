import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/exploration/model/explore_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_pagination_shortform_repository.dart';

final guestUserExploreShortFormProvider = StateNotifierProvider.autoDispose<
    GuestUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(guestUserPaginationShortFormRepositoryProvider);
    final category = ref.watch(explorationCategoryProvider);

    return GuestUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/search/news/filter/guest',
      additionalParams: ExploreShortFormAdditionalParams(
        category: category,
      ),
    );
  },
);
