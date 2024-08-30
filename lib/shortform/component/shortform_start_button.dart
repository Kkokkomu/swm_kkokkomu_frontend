import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class ShortFormStartButton extends StatelessWidget {
  const ShortFormStartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorName.gray700.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: ColorName.blue500,
          size: 40.0,
        ),
      )
          .animate()
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
