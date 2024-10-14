import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_pagination_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/model/search_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_sort_type_provider.dart';

final loggedInUserSearchShortFormProvider = StateNotifierProvider.autoDispose
    .family<LoggedInUserPaginationShortFormStateNotifier, CursorPaginationBase,
        String>(
  (ref, searchKeyword) {
    final shortFormPaginationRepository =
        ref.watch(loggedInUserPaginationShortFormRepositoryProvider);
    final category = ref.watch(searchShortFormCategoryProvider);
    final sortType = ref.watch(searchShortFormSortTypeProvider);

    return LoggedInUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/search/news',
      ref: ref,
      additionalParams: SearchShortFormAdditionalParams(
        text: searchKeyword,
        category: category.categoriesToString(),
        filter: sortType,
      ),
    );
  },
);
