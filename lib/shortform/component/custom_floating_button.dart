import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomFloatingButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final Color labelColor;
  final void Function()? onTap;

  const CustomFloatingButton({
    super.key,
    required this.icon,
    this.label,
    this.labelColor = ColorName.white000,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: Constants.shortFormFloatingButtonSize,
            height: Constants.shortFormFloatingButtonSize,
            child: FittedBox(child: icon),
          ),
        ),
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 12.0,
              color: labelColor,
            ),
          ),
      ],
    );
  }
}
