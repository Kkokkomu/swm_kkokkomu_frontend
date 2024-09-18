import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/home_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_pagination_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';

final loggedInUserHomeShortFormProvider = StateNotifierProvider.autoDispose<
    LoggedInUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(loggedInUserPaginationShortFormRepositoryProvider);
    final userShortFormSetting =
        ref.watch(loggedInUserShortFormSettingProvider);

    return LoggedInUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/home/news/list',
      ref: ref,
      additionalParams: HomeShortFormAdditionalParams(
        filter: userShortFormSetting.shortFormSortType,
      ),
    );
  },
);

class LoggedInUserPaginationShortFormStateNotifier
    extends CursorPaginationProvider<PaginationShortFormModel,
        LoggedInUserPaginationShortFormRepository> {
  final Ref ref;

  LoggedInUserPaginationShortFormStateNotifier(
    super.repository,
    super.apiPath, {
    required this.ref,
    super.additionalParams,
  });
}
