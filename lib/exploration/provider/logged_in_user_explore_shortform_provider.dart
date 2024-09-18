import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/exploration/model/explore_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_pagination_shortform_repository.dart';

final loggedInUserExploreShortFormProvider = StateNotifierProvider.autoDispose<
    LoggedInUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(loggedInUserPaginationShortFormRepositoryProvider);
    final category = ref.watch(explorationCategoryProvider);

    return LoggedInUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/search/news/filter',
      ref: ref,
      additionalParams: ExploreShortFormAdditionalParams(
        category: category,
      ),
    );
  },
);
