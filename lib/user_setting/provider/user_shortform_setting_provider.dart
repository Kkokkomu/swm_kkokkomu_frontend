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
    final prefs = await SharedPreferences.getInstance();
    final sortTypeName =
        prefs.getString(SharedPreferencesKeys.shortFormSortType);

    if (sortTypeName == null) {
      await _saveSortType(ShortFormSortType.recommend);
      return ShortFormSortType.recommend;
    }

    final sortType = ShortFormSortType.fromName(sortTypeName);

    if (sortType == null) {
      await _saveSortType(ShortFormSortType.recommend);
      return ShortFormSortType.recommend;
    }

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

  Future<void> _saveSortType(ShortFormSortType sortType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedPreferencesKeys.shortFormSortType,
      sortType.name,
    );
  }
}
