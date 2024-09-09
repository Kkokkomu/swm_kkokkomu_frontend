import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_category_filter_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_setting_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/repository/logged_in_user_setting_repository.dart';

final loggedInUserShortFormSettingProvider = StateNotifierProvider<
    LoggedInUserShortFormSettingStateNotifier, UserShortFormSettingModel>(
  (ref) {
    final loggedInUserSettingRepository =
        ref.watch(loggedInUserSettingRepositoryProvider);

    return LoggedInUserShortFormSettingStateNotifier(
      loggedInUserSettingRepository: loggedInUserSettingRepository,
    );
  },
);

class LoggedInUserShortFormSettingStateNotifier
    extends StateNotifier<UserShortFormSettingModel> {
  final LoggedInUserSettingRepository loggedInUserSettingRepository;

  LoggedInUserShortFormSettingStateNotifier({
    required this.loggedInUserSettingRepository,
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

  Future<bool> updateSetting({
    required UserShortFormSettingModel setting,
  }) async {
    // 세팅값 업데이트
    // 만약 모든 카테고리가 선택되어 있지 않다면 모든 카테고리를 선택하도록 변경
    // 모두 false == 모두 true 로 취급
    final newSetting = setting.isAllCategoryUnSelected()
        ? setting.copyWith(
            userShortFormCategoryFilter:
                setting.userShortFormCategoryFilter.copyWith(
              politics: true,
              economy: true,
              social: true,
              entertain: true,
              sports: true,
              living: true,
              world: true,
              it: true,
            ),
          )
        : setting;

    // 변경된 설정을 적용
    state = newSetting;

    // 변경된 정렬 설정을 SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    await _saveSortType(prefs, newSetting.shortFormSortType);

    // 변경된 카테고리 설정을 서버에 저장
    final resp =
        await loggedInUserSettingRepository.updateUserShortFormCategoryFilter(
      body: newSetting.userShortFormCategoryFilter,
    );

    // 서버에 저장에 실패했다면 false 반환
    if (resp.success != true) {
      return false;
    }

    // 서버에 저장에 성공했다면 true 반환
    return true;
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
    // 서버로부터 UserShortFormCategoryFilter를 가져옴
    final response =
        await loggedInUserSettingRepository.getUserShortFormCategoryFilter();

    final categoryFilter = response.data;

    // 서버로부터 가져온 값이 없다면 초기 값(기본 값) 반환
    if (response.success != true || categoryFilter == null) {
      return state.userShortFormCategoryFilter;
    }

    // 서버로부터 가져온 값이 있다면 반환
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
