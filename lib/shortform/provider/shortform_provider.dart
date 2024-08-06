import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_repository.dart';

final shortFormProvider =
    StateNotifierProvider<ShortFormStateNotifier, OffsetPaginationBase>(
  (ref) {
    final shortFormRepository = ref.watch(shortFormRepositoryProvider);

    return ShortFormStateNotifier(
      ref: ref,
      repository: shortFormRepository,
    );
  },
);

class ShortFormStateNotifier
    extends PaginationProvider<ShortFormModel, ShortFormRepository> {
  final Ref ref;

  ShortFormStateNotifier({
    required this.ref,
    required super.repository,
  });
}
