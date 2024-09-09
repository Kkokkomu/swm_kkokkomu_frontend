import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

final shortFormReportTypeProvider =
    StateProvider.autoDispose<ShortFormReportType>(
  (ref) => ShortFormReportType.misinformation,
);
