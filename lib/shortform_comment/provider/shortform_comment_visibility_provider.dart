import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_toggle.dart';
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
  Timer? toggleBottomNavigationBarTimer;

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
    toggleBottomNavigationBarTimer?.cancel();
    if (state.isShortFormCommentVisible) {
      toggleBottomNavigationBarTimer =
          Timer(const Duration(milliseconds: 300), () {
        ref.read(bottomNavigationBarToggleProvider.notifier).state = true;
      });
    } else {
      ref.read(bottomNavigationBarToggleProvider.notifier).state = false;
    }

    state = state.copyWith(
      isShortFormCommentVisible: !state.isShortFormCommentVisible,
      isShortFormCommentTapped: true,
    );
  }
}
