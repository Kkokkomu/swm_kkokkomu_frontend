import 'package:flutter_riverpod/flutter_riverpod.dart';

final shortFormLikeButtonAnimationTriggerProvider =
    StateProvider.family.autoDispose<bool, int>(
  (ref, commentId) => false,
);
