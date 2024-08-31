import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_height_controller_model.dart';

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
            isShortFormCommentCreated: false,
            isShortFormCommentVisible: false,
            height: 0.0,
            animationDuration:
                AnimationDuration.shortFormCommentAnimationDuration,
          ),
        );

  void setShortFormCommentVisibility(bool isVisible) {
    // 변경사항이 없는 경우 아무것도 수행하지 않음
    if (state.isShortFormCommentCreated == true &&
        state.isShortFormCommentVisible == isVisible) return;

    state = state.copyWith(
      isShortFormCommentCreated: true,
      isShortFormCommentVisible: isVisible,
    );
  }

  void onVerticalDragUpdate(DragUpdateDetails details, double maxHeight) {
    // 댓글이 보이지 않는 상태에서는 높이 조절이 불가능하도록 설정
    if (!state.isShortFormCommentVisible) {
      return;
    }

    // 변경된 높이를 계산
    double commentBodyHeight = state.height - details.delta.dy;

    // 댓글 높이가 0.01 보다 작으면 0.01로 설정
    // 댓글 높이가 maxHeight 보다 크면 maxHeight로 설정
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
    // 댓글이 보이지 않는 상태에서는 높이 조절이 불가능하도록 설정
    if (!state.isShortFormCommentVisible) {
      return;
    }

    // 댓글 창 조절 가속도에 따라 댓글 창 크기 조절
    bool isScrollUp = details.velocity.pixelsPerSecond.dy <= -500.0;
    bool isScrollDown = details.velocity.pixelsPerSecond.dy >= 500.0;

    if (state.height >= maxHeight * 0.75) {
      // 댓글 창 높이가 75% 이상일 때
      // 댓글 창을 아래로 내리면 Medium, 아니면 Large로 설정
      if (isScrollDown) {
        setCommentBodySizeMedium(maxHeight);
      } else {
        setCommentBodySizeLarge(maxHeight);
      }
    } else if (state.height <= maxHeight * 0.45) {
      // 댓글 창 높이가 45% 이하일 때
      // 댓글 창을 위로 올리면 Medium, 아니면 Small로 설정
      if (isScrollUp) {
        setCommentBodySizeMedium(maxHeight);
      } else {
        setCommentBodySizeSmall();
      }
    } else {
      // 댓글 창 높이가 45% 초과 75% 미만일 때
      // 댓글 창을 위로 올리면 Large, 아래로 내리면 Small로 설정, 그 외에는 Medium으로 설정
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
    // 댓글이 보이는 상태에서는 BottomNavigationBar 가 사라지도록 설정
    ref
        .read(bottomNavigationBarStateProvider.notifier)
        .setBottomNavigationBarVisibility(false);

    // 댓글 창 크기 조절 시 댓글 창이 보이도록 설정
    setShortFormCommentVisibility(true);

    state = state.copyWith(
      height: maxHeight,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }

  void setCommentBodySizeMedium(double maxHeight) {
    // 댓글이 보이는 상태에서는 BottomNavigationBar 가 사라지도록 설정
    ref
        .read(bottomNavigationBarStateProvider.notifier)
        .setBottomNavigationBarVisibility(false);

    // 댓글 창 크기 조절 시 댓글 창이 보이도록 설정
    setShortFormCommentVisibility(true);

    state = state.copyWith(
      height: maxHeight * 0.6,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }

  void setCommentBodySizeSmall() {
    // 댓글 높이 Small로 설정할 경우 댓글 창이 사라지도록 설정

    // 댓글이 사라지면 BottomNavigationBar 가 보이도록 설정
    ref
        .read(bottomNavigationBarStateProvider.notifier)
        .setBottomNavigationBarVisibility(true);

    // 댓글 창 닫을 시 댓글 창이 사라지도록 설정
    setShortFormCommentVisibility(false);

    state = state.copyWith(
      height: 0.0,
      animationDuration: AnimationDuration.shortFormCommentAnimationDuration,
    );
  }
}
