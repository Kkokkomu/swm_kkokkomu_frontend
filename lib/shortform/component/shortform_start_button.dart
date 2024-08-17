import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

class ShortFormStartButton extends StatefulWidget {
  const ShortFormStartButton({
    super.key,
  });

  @override
  State<ShortFormStartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<ShortFormStartButton> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scale = 1.0;
        });
      }

      Future.delayed(
          AnimationDuration.startPauseButtonScaleAnimationDuration +
              AnimationDuration.startPauseButtonHoldDuration, () {
        if (mounted) {
          setState(() {
            _scale = 0.0;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: AnimationDuration.startPauseButtonScaleAnimationDuration,
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}
