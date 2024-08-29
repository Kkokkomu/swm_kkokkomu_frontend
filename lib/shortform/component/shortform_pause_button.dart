import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class ShortFormPauseButton extends StatelessWidget {
  const ShortFormPauseButton({
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
          Icons.pause,
          color: ColorName.blue500,
          size: 40.0,
        ),
      )
          .animate()
          .scale(
            duration: AnimationDuration.startPauseButtonScaleAnimationDuration,
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
          )
          .then(delay: AnimationDuration.startPauseButtonHoldDuration)
          .scale(
            duration: AnimationDuration.startPauseButtonScaleAnimationDuration,
            begin: const Offset(1.0, 1.0),
            end: const Offset(0.0, 0.0),
          ),
    );
  }
}
