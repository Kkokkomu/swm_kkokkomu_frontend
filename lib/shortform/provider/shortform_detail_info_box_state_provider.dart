import 'package:flutter_riverpod/flutter_riverpod.dart';

final shortFormDetailInfoBoxStateProvider =
    StateProvider.autoDispose.family<bool, int>(
  (ref, newsId) {
    return false;
  },
);
