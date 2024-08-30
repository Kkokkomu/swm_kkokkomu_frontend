import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';

final detailEmojiButtonVisibilityProvider = StateNotifierProvider.autoDispose
    .family<DetailEmojiButtonVisibilityStateNotifier, bool, int>(
  (ref, newsId) => DetailEmojiButtonVisibilityStateNotifier(ref: ref),
);

class DetailEmojiButtonVisibilityStateNotifier extends StateNotifier<bool> {
  final Ref ref;

  DetailEmojiButtonVisibilityStateNotifier({
    required this.ref,
  }) : super(false);

  void setDetailEmojiButtonVisibility(bool isVisible) {
    // 현재 상태와 동일하면 무시
    if (isVisible == state) return;

    state = isVisible;
    ref
        .read(bottomNavigationBarStateProvider.notifier)
        .setModalBarrierVisibility(isVisible);
  }
}
