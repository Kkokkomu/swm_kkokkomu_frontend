import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/short_form_play_pause_button_visibility_provider.dart';

class ShortFormStartPauseButton extends ConsumerWidget {
  final int newsId;

  const ShortFormStartPauseButton({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonVisibility = ref.watch(
      shortFormPlayPauseButtonVisibilityProvider(newsId),
    );

    // 버튼이 보이지 않는 경우 빈 위젯을 반환
    if (!buttonVisibility.isButtonVisible) {
      return const SizedBox();
    }

    return buttonVisibility.isPlaying
        ? _StartButton(newsId: newsId)
        : _PauseButton(newsId: newsId);
  }
}

class _StartButton extends StatelessWidget {
  final int newsId;

  const _StartButton({
    required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    return _StartPauseButton(newsId: newsId, isPlaying: true);
  }
}

class _PauseButton extends StatelessWidget {
  final int newsId;

  const _PauseButton({
    required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    return _StartPauseButton(newsId: newsId, isPlaying: false);
  }
}

class _StartPauseButton extends ConsumerWidget {
  final int newsId;
  final bool isPlaying;

  const _StartPauseButton({
    required this.newsId,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorName.gray700.withOpacity(0.5),
        ),
        child: Icon(
          isPlaying ? Icons.play_arrow : Icons.pause,
          color: ColorName.blue500,
          size: 40.0,
        ),
      )
          .animate(
            onComplete: (_) => ref
                .read(
                    shortFormPlayPauseButtonVisibilityProvider(newsId).notifier)
                .state = (isButtonVisible: false, isPlaying: isPlaying),
          )
          .scaleXY(
            duration: AnimationDuration.startPauseButtonScaleAnimationDuration,
            begin: 0.0,
            end: 1.0,
          )
          .then(delay: AnimationDuration.startPauseButtonHoldDuration)
          .scaleXY(
            duration: AnimationDuration.startPauseButtonScaleAnimationDuration,
            begin: 1.0,
            end: 0.0,
          ),
    );
  }
}
