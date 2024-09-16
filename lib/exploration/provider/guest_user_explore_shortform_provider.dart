import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/exploration/model/explore_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_shortform_repository.dart';

final guestUserExploreShortFormProvider = StateNotifierProvider.autoDispose<
    GuestUserShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final exploreShortFormRepository =
        ref.watch(guestUserShortFormRepositoryProvider);
    final category = ref.watch(explorationCategoryProvider);

    return GuestUserShortFormStateNotifier(
      exploreShortFormRepository,
      '/search/news/filter/guest',
      additionalParams: ExploreShortFormAdditionalParams(
        category: category,
      ),
    );
  },
);
