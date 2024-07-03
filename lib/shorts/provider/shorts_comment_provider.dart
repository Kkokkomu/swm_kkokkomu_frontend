import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_toggle.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shorts_comment_model.dart';

final shortsCommentVisibilityProvider = StateNotifierProvider.family
    .autoDispose<ShortsCommentVisibilityStateNotifier,
        ShortsCommentVisibleModel, int>(
  (ref, newsID) {
    return ShortsCommentVisibilityStateNotifier(
      ref: ref,
      newsID: newsID,
    );
  },
);

class ShortsCommentVisibilityStateNotifier
    extends StateNotifier<ShortsCommentVisibleModel> {
  final Ref ref;
  final int newsID;
  Timer? toggleBottomNavigationBarTimer;

  ShortsCommentVisibilityStateNotifier({
    required this.ref,
    required this.newsID,
  }) : super(
          ShortsCommentVisibleModel(
            id: newsID,
            isShortsCommentTapped: false,
            isShortsCommentVisible: false,
          ),
        );

  void toggleShortsCommentVisibility() {
    toggleBottomNavigationBarTimer?.cancel();
    if (state.isShortsCommentVisible) {
      toggleBottomNavigationBarTimer =
          Timer(const Duration(milliseconds: 300), () {
        ref.read(bottomNavigationBarToggleProvider.notifier).state = true;
      });
    } else {
      ref.read(bottomNavigationBarToggleProvider.notifier).state = false;
    }

    state = state.copyWith(
      isShortsCommentVisible: !state.isShortsCommentVisible,
      isShortsCommentTapped: true,
    );
  }
}
