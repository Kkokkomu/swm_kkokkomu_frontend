import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_pagination_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/model/search_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_sort_type_provider.dart';

final guestUserSearchShortFormProvider = StateNotifierProvider.autoDispose
    .family<GuestUserPaginationShortFormStateNotifier, CursorPaginationBase,
        String>(
  (ref, searchKeyword) {
    final shortFormPaginationRepository =
        ref.watch(guestUserPaginationShortFormRepositoryProvider);
    final category = ref.watch(searchShortFormCategoryProvider);
    final sortType = ref.watch(searchShortFormSortTypeProvider);

    return GuestUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/search/news/guest',
      additionalParams: SearchShortFormAdditionalParams(
        text: searchKeyword,
        category: category.categoriesToString(),
        filter: sortType,
      ),
    );
  },
);
