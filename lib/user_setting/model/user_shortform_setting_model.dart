import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
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
      categories.add(NewsCategory.politics.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.economy) {
      categories.add(NewsCategory.economy.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.social) {
      categories.add(NewsCategory.social.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.entertain) {
      categories.add(NewsCategory.entertain.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.sports) {
      categories.add(NewsCategory.sports.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.living) {
      categories.add(NewsCategory.living.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.world) {
      categories.add(NewsCategory.world.name.toLowerCase());
    }
    if (userShortFormCategoryFilter.it) {
      categories.add(NewsCategory.it.name.toLowerCase());
    }

    return categories.join(',');
  }

  bool isCategorySelected(NewsCategory category) => switch (category) {
        NewsCategory.politics => userShortFormCategoryFilter.politics,
        NewsCategory.economy => userShortFormCategoryFilter.economy,
        NewsCategory.social => userShortFormCategoryFilter.social,
        NewsCategory.entertain => userShortFormCategoryFilter.entertain,
        NewsCategory.sports => userShortFormCategoryFilter.sports,
        NewsCategory.living => userShortFormCategoryFilter.living,
        NewsCategory.world => userShortFormCategoryFilter.world,
        NewsCategory.it => userShortFormCategoryFilter.it
      };

  bool isAllCategorySelected() =>
      userShortFormCategoryFilter.politics &&
      userShortFormCategoryFilter.economy &&
      userShortFormCategoryFilter.social &&
      userShortFormCategoryFilter.entertain &&
      userShortFormCategoryFilter.sports &&
      userShortFormCategoryFilter.living &&
      userShortFormCategoryFilter.world &&
      userShortFormCategoryFilter.it;

  bool isAllCategoryUnSelected() =>
      !userShortFormCategoryFilter.politics &&
      !userShortFormCategoryFilter.economy &&
      !userShortFormCategoryFilter.social &&
      !userShortFormCategoryFilter.entertain &&
      !userShortFormCategoryFilter.sports &&
      !userShortFormCategoryFilter.living &&
      !userShortFormCategoryFilter.world &&
      !userShortFormCategoryFilter.it;

  UserShortFormSettingModel copyWith({
    UserShortFormCategoryFilterModel? userShortFormCategoryFilter,
    ShortFormSortType? shortFormSortType,
  }) {
    return UserShortFormSettingModel(
      userShortFormCategoryFilter:
          userShortFormCategoryFilter ?? this.userShortFormCategoryFilter,
      shortFormSortType: shortFormSortType ?? this.shortFormSortType,
    );
  }
}
