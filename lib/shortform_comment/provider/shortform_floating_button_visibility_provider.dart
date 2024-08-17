import 'package:flutter_riverpod/flutter_riverpod.dart';

final shortFormFloatingButtonVisibilityProvider =
    StateProvider.family.autoDispose<bool, int>(
  (ref, newsId) => true,
);
