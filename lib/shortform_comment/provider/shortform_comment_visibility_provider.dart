import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_visibility_model.dart';

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

    // 댓글창 등장시 하단 네비게이션바 숨기기
    if (state.isShortFormCommentVisible) {
      ref.read(bottomNavigationBarStateProvider.notifier).state = false;
    }
  }
}
