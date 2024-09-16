import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_shortform_repository.dart';

final guestUserHomeShortFormProvider = StateNotifierProvider.autoDispose<
    GuestUserShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormRepository = ref.watch(guestUserShortFormRepositoryProvider);

    return GuestUserShortFormStateNotifier(
      shortFormRepository,
      '/home/news/list/guest',
    );
  },
);

class GuestUserShortFormStateNotifier extends CursorPaginationProvider<
    ShortFormModel, GuestUserShortFormRepository> {
  GuestUserShortFormStateNotifier(
    super.repository,
    super.apiPath, {
    super.additionalParams,
  });
}
