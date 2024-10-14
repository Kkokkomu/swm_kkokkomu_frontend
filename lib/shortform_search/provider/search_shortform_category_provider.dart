import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/model/search_shortform_category_filter_model.dart';

final searchShortFormCategoryProvider =
    StateProvider.autoDispose<SearchShortFormCategoryFilterModel>(
  (ref) => SearchShortFormCategoryFilterModel(),
);
