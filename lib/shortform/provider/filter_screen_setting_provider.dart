import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_setting_model.dart';

final filterScreenSettingProvider = StateNotifierProvider.autoDispose.family<
    FilterScreenSettingNotifier,
    UserShortFormSettingModel,
    UserShortFormSettingModel>(
  (ref, setting) {
    return FilterScreenSettingNotifier(setting: setting);
  },
);

class FilterScreenSettingNotifier
    extends StateNotifier<UserShortFormSettingModel> {
  FilterScreenSettingNotifier({
    required UserShortFormSettingModel setting,
  }) : super(
          // 기존에 저장된 설정을 가져옴
          // 기존에 모든 카테고리가 설정되어 있었다면 모든 카테고리를 false로 변경
          // 모두 false == 모두 true 로 취급
          // 마지막 적용버튼 누를 때 모두 false인 경우 모두 true로 변경하여 적용
          setting.isAllCategorySelected()
              ? setting.copyWith(
                  userShortFormCategoryFilter:
                      setting.userShortFormCategoryFilter.copyWith(
                    politics: false,
                    economy: false,
                    social: false,
                    entertain: false,
                    sports: false,
                    living: false,
                    world: false,
                    it: false,
                  ),
                )
              : setting.copyWith(),
        );

  void setSortType(ShortFormSortType sortType) =>
      state = state.copyWith(shortFormSortType: sortType);

  void toggleCategory(NewsCategory category) {
    switch (category) {
      case NewsCategory.politics:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            politics: !state.userShortFormCategoryFilter.politics,
          ),
        );
        break;
      case NewsCategory.economy:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            economy: !state.userShortFormCategoryFilter.economy,
          ),
        );
        break;
      case NewsCategory.social:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            social: !state.userShortFormCategoryFilter.social,
          ),
        );
        break;
      case NewsCategory.entertain:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            entertain: !state.userShortFormCategoryFilter.entertain,
          ),
        );
        break;
      case NewsCategory.sports:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            sports: !state.userShortFormCategoryFilter.sports,
          ),
        );
        break;
      case NewsCategory.living:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            living: !state.userShortFormCategoryFilter.living,
          ),
        );
        break;
      case NewsCategory.world:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            world: !state.userShortFormCategoryFilter.world,
          ),
        );
        break;
      case NewsCategory.it:
        state = state.copyWith(
          userShortFormCategoryFilter:
              state.userShortFormCategoryFilter.copyWith(
            it: !state.userShortFormCategoryFilter.it,
          ),
        );
        break;
    }
  }

  void reset() => state = state.copyWith(
        userShortFormCategoryFilter: state.userShortFormCategoryFilter.copyWith(
          politics: false,
          economy: false,
          social: false,
          entertain: false,
          sports: false,
          living: false,
          world: false,
          it: false,
        ),
        shortFormSortType: ShortFormSortType.recommend,
      );
}
