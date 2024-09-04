import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/offset_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';

final loggedInUserShortFormProvider = StateNotifierProvider.autoDispose<
    LoggedInUserShortFormStateNotifier, OffsetPaginationBase>(
  (ref) {
    final shortFormRepository =
        ref.watch(loggedInUserShortFormRepositoryProvider);
    final userShortFormSetting =
        ref.watch(loggedInUserShortFormSettingProvider);

    return LoggedInUserShortFormStateNotifier(
      shortFormRepository,
      additionalParams: ShortFormAdditionalParams(
        category: userShortFormSetting.categoriesToString(),
        filter: userShortFormSetting.shortFormSortType,
      ),
    );
  },
);

class LoggedInUserShortFormStateNotifier extends OffsetPaginationProvider<
    ShortFormModel, LoggedInUserShortFormRepository> {
  LoggedInUserShortFormStateNotifier(
    super.repository, {
    super.additionalParams,
  });
}
