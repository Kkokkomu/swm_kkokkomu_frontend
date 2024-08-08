import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_category_filter_model.dart';

class UserShortFormSettingModel {
  final UserShortFormCategoryFilterModel userShortFormCategoryFilter;
  final ShortFormSortType shortFormSortType;

  UserShortFormSettingModel({
    required this.userShortFormCategoryFilter,
    required this.shortFormSortType,
  });

  String categoriesToString() {
    final categories = <String>[];

    if (userShortFormCategoryFilter.politics) {
      categories.add(NewsCategory.politics.name);
    }
    if (userShortFormCategoryFilter.economy) {
      categories.add(NewsCategory.economy.name);
    }
    if (userShortFormCategoryFilter.social) {
      categories.add(NewsCategory.social.name);
    }
    if (userShortFormCategoryFilter.entertain) {
      categories.add(NewsCategory.entertain.name);
    }
    if (userShortFormCategoryFilter.sports) {
      categories.add(NewsCategory.sports.name);
    }
    if (userShortFormCategoryFilter.living) {
      categories.add(NewsCategory.living.name);
    }
    if (userShortFormCategoryFilter.world) {
      categories.add(NewsCategory.world.name);
    }
    if (userShortFormCategoryFilter.it) {
      categories.add(NewsCategory.it.name);
    }

    return categories.join(',');
  }
}
