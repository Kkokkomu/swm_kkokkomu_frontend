import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final shortFormProvider =
    StateNotifierProvider<ShortFormStateNotifier, OffsetPaginationBase>(
  (ref) {
    final shortFormRepository = ref.watch(shortFormRepositoryProvider);
    final userInfo = ref.watch(userInfoProvider) as UserModel;

    return ShortFormStateNotifier(
      ref: ref,
      repository: shortFormRepository,
      additionalParams: ShortFormAdditionalParams(userId: userInfo.id),
    );
  },
);

class ShortFormStateNotifier
    extends PaginationProvider<ShortFormModel, ShortFormRepository> {
  final Ref ref;

  ShortFormStateNotifier({
    required this.ref,
    required super.repository,
    required super.additionalParams,
  });
}
