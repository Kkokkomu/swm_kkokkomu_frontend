import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_pagination_shortform_repository.dart';

final guestUserHomeShortFormProvider = StateNotifierProvider.autoDispose<
    GuestUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(guestUserPaginationShortFormRepositoryProvider);

    return GuestUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/home/news/list/guest',
    );
  },
);

class GuestUserPaginationShortFormStateNotifier
    extends CursorPaginationProvider<PaginationShortFormModel,
        GuestUserPaginationShortFormRepository> {
  GuestUserPaginationShortFormStateNotifier(
    super.repository,
    super.apiPath, {
    super.additionalParams,
  });
}
