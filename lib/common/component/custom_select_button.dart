import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomSelectButton extends StatelessWidget {
  final String content;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomSelectButton({
    super.key,
    required this.content,
    this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.0,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorName.gray600,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            content,
            style: CustomTextStyle.body1Bold(
              color: textColor ?? ColorName.white000,
            ),
          ),
        ),
      ),
    );
  }
}
