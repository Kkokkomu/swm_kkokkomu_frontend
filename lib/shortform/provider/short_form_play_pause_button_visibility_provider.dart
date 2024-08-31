import 'package:flutter_riverpod/flutter_riverpod.dart';

final shortFormPlayPauseButtonVisibilityProvider = StateProvider.autoDispose
    .family<({bool isButtonVisible, bool isPlaying}), int>(
  (ref, newsId) => (isButtonVisible: false, isPlaying: true),
);
