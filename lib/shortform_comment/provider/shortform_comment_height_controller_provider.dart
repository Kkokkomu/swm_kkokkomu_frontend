import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_height_controller_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_visibility_provider.dart';

final shortFormCommentHeightControllerProvider = StateNotifierProvider.family
    .autoDispose<ShortFormCommentHeightStateNotifier,
        ShortformCommentHeightControllerModel, int>(
  (ref, newsId) {
    return ShortFormCommentHeightStateNotifier(
      ref: ref,
      newsId: newsId,
    );
  },
);

class ShortFormCommentHeightStateNotifier
    extends StateNotifier<ShortformCommentHeightControllerModel> {
  final Ref ref;

  ShortFormCommentHeightStateNotifier({
    required this.ref,
    required int newsId,
  }) : super(
          ShortformCommentHeightControllerModel(
            newsId: newsId,
            height: 0.0,
            animationDuration:
                AnimationDuration.shortFormCommentAnimationDuration,
          ),
        );

  void onVerticalDragUpdate(DragUpdateDetails details, double maxHeight) {
    if (!ref
        .read(shortFormCommentVisibilityProvider(state.newsId))
        .isShortFormCommentVisible) {
      return;
    }

    double commentBodyHeight = state.height - details.delta.dy;

    if (commentBodyHeight < 0.01) {
      commentBodyHeight = 0.01;
    } else if (commentBodyHeight > maxHeight) {
      commentBodyHeight = maxHeight;
    }

    state = state.copyWith(
      height: commentBodyHeight,
      animationDuration: Duration.zero,
    );
  }

  void onVerticalDragEnd(DragEndDetails details, double maxHeight) {
    if (!ref
        .read(shortFormCommentVisibilityProvider(state.newsId))
        .isShortFormCommentVisible) {
      return;
    }

    bool isScrollUp = details.velocity.pixelsPerSecond.dy <= -500.0;
    bool isScrollDown = details.velocity.pixelsPerSecond.dy >= 500.0;

    if (state.height >= maxHeight * 0.75) {
      if (isScrollDown) {
        setCommentBodySizeMedium(maxHeight);
      } else {
        setCommentBodySizeLarge(maxHeight);
      }
    } else if (state.height <= maxHeight * 0.45) {
      if (isScrollUp) {
        setCommentBodySizeMedium(maxHeight);
      } else {
        setCommentBodySizeSmall();
      }
    } else {
      if (isScrollUp) {
        setCommentBodySizeLarge(maxHeight);
      } else if (isScrollDown) {
        setCommentBodySizeSmall();
      } else {
        setCommentBodySizeMedium(maxHeight);
      }
    }
  }

  void setCommentBodySizeLarge(double maxHeight) {
    ref.read(bottomNavigationBarStateProvider.notifier).state = false;

    ref
        .read(shortFormCommentVisibilityProvider(state.newsId).notifier)
        .setShortFormCommentVisibility(true);

    state = state.copyWith(
      height: maxHeight,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }

  void setCommentBodySizeMedium(double maxHeight) {
    ref.read(bottomNavigationBarStateProvider.notifier).state = false;

    ref
        .read(shortFormCommentVisibilityProvider(state.newsId).notifier)
        .setShortFormCommentVisibility(true);

    state = state.copyWith(
      height: maxHeight * 0.6,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }

  void setCommentBodySizeSmall() {
    ref.read(bottomNavigationBarStateProvider.notifier).state = true;

    ref
        .read(shortFormCommentVisibilityProvider(state.newsId).notifier)
        .setShortFormCommentVisibility(false);

    state = state.copyWith(
      height: 0.0,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }
}
