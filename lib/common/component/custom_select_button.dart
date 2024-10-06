import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomSelectButton extends StatelessWidget {
  final String content;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final bool? isInkWell;
  final Widget? prefixIcon;

  const CustomSelectButton({
    super.key,
    required this.content,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.isInkWell = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return isInkWell == true
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: onTap,
              child: Ink(
                width: double.infinity,
                height: 52.0,
                decoration: BoxDecoration(
                  color: backgroundColor ?? ColorName.gray600,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _CustomSelectButtonContent(
                  prefixIcon: prefixIcon,
                  content: content,
                  textStyle: textStyle,
                  textColor: textColor,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 52.0,
              decoration: BoxDecoration(
                color: backgroundColor ?? ColorName.gray600,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _CustomSelectButtonContent(
                prefixIcon: prefixIcon,
                content: content,
                textStyle: textStyle,
                textColor: textColor,
              ),
            ),
          );
  }
}

class _CustomSelectButtonContent extends StatelessWidget {
  final Widget? prefixIcon;
  final String content;
  final TextStyle? textStyle;
  final Color? textColor;

  const _CustomSelectButtonContent({
    required this.prefixIcon,
    required this.content,
    required this.textStyle,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) prefixIcon!,
          if (prefixIcon != null) const SizedBox(width: 4.0),
          Text(
            content,
            style: textStyle ??
                CustomTextStyle.body1Bold(
                  color: textColor ?? ColorName.white000,
                ),
          ),
        ],
      ),
    );
  }
}
