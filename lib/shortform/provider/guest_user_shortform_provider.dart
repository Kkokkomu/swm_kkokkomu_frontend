import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/offset_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/guest_user_shortform_repository.dart';

final guestUserShortFormProvider = StateNotifierProvider<
    GuestUserShortFormStateNotifier, OffsetPaginationBase>(
  (ref) {
    final shortFormRepository = ref.watch(guestUserShortFormRepositoryProvider);

    return GuestUserShortFormStateNotifier(shortFormRepository);
  },
);

class GuestUserShortFormStateNotifier extends OffsetPaginationProvider<
    ShortFormModel, GuestUserShortFormRepository> {
  GuestUserShortFormStateNotifier(
    super.repository, {
    super.additionalParams,
  });
}
