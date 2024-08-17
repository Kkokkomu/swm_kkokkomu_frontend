import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_visibility_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_floating_button_visibility_provider.dart';

final shortFormCommentVisibilityProvider = StateNotifierProvider.family
    .autoDispose<ShortFormCommentVisibilityStateNotifier,
        ShortFormCommentVisibilityModel, int>(
  (ref, newsID) {
    return ShortFormCommentVisibilityStateNotifier(
      ref: ref,
      newsID: newsID,
    );
  },
);

class ShortFormCommentVisibilityStateNotifier
    extends StateNotifier<ShortFormCommentVisibilityModel> {
  final Ref ref;
  final int newsID;

  ShortFormCommentVisibilityStateNotifier({
    required this.ref,
    required this.newsID,
  }) : super(
          ShortFormCommentVisibilityModel(
            newsId: newsID,
            isShortFormCommentTapped: false,
            isShortFormCommentVisible: false,
          ),
        );

  void toggleShortFormCommentVisibility() {
    state = state.copyWith(
      isShortFormCommentVisible: !state.isShortFormCommentVisible,
      isShortFormCommentTapped: true,
    );

    // 댓글창 On/Off 시 BottomNavigationBar는 Off/On
    ref.read(bottomNavigationBarStateProvider.notifier).state =
        !state.isShortFormCommentVisible;

    // 댓글창이 열리면 숏폼 플로팅 버튼 숨김
    if (state.isShortFormCommentVisible) {
      ref
          .read(shortFormFloatingButtonVisibilityProvider(newsID).notifier)
          .state = false;
    }
  }
}
