import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_category_filter_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_setting_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/repository/user_setting_repository.dart';

final userShortFormSettingProvider = StateNotifierProvider<
    UserShortFormSettingStateNotifier, UserShortFormSettingModel>(
  (ref) {
    final userSettingRepository = ref.watch(userSettingRepositoryProvider);

    return UserShortFormSettingStateNotifier(
      userSettingRepository: userSettingRepository,
    );
  },
);

class UserShortFormSettingStateNotifier
    extends StateNotifier<UserShortFormSettingModel> {
  final UserSettingRepository userSettingRepository;

  UserShortFormSettingStateNotifier({
    required this.userSettingRepository,
  }) : super(
          UserShortFormSettingModel(
            userShortFormCategoryFilter: UserShortFormCategoryFilterModel(
              politics: true,
              economy: true,
              social: true,
              entertain: true,
              sports: true,
              living: true,
              world: true,
              it: true,
            ),
            shortFormSortType: ShortFormSortType.recommend,
          ),
        );

  Future<void> getSetting() async {
    final sortType = await _getSortType();
    final categoryFilter = await _getCategoryFilter();

    state = UserShortFormSettingModel(
      userShortFormCategoryFilter: categoryFilter,
      shortFormSortType: sortType,
    );
  }

  Future<ShortFormSortType> _getSortType() async {
    // SharedPreferences에 저장된 ShortFormSortType을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final sortTypeName =
        prefs.getString(SharedPreferencesKeys.shortFormSortType);

    // 저장된 값이 없다면 기본값을 저장하고 반환
    if (sortTypeName == null) {
      await _saveSortType(prefs, ShortFormSortType.recommend);
      return ShortFormSortType.recommend;
    }

    // 저장된 값이 있다면 enum으로 변환하여 반환
    final sortType = ShortFormSortType.fromName(sortTypeName);

    // 변환에 실패했다면 기본값을 저장하고 반환
    if (sortType == null) {
      await _saveSortType(prefs, ShortFormSortType.recommend);
      return ShortFormSortType.recommend;
    }

    // 변환에 성공했다면 sortType enum 반환
    return sortType;
  }

  Future<UserShortFormCategoryFilterModel> _getCategoryFilter() async {
    final response =
        await userSettingRepository.getUserShortFormCategoryFilter();

    final categoryFilter = response.data;

    if (response.success != true || categoryFilter == null) {
      return state.userShortFormCategoryFilter;
    }

    return categoryFilter;
  }

  Future<void> _saveSortType(
    SharedPreferences prefs,
    ShortFormSortType sortType,
  ) async =>
      await prefs.setString(
        SharedPreferencesKeys.shortFormSortType,
        sortType.name,
      );
}
