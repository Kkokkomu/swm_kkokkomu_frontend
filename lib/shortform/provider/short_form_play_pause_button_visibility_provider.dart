import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

final shortFormPlayPauseButtonVisibilityProvider = StateProvider.autoDispose
    .family<({bool isButtonVisible, bool isPlaying}),
        ({int newsId, ShortFormScreenType shortFormScreenType})>(
  (ref, shortFormInfo) => (isButtonVisible: false, isPlaying: true),
);
