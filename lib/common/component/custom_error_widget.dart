import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorText;
  final String? firstButtonText;
  final String? secondButtonText;
  final Widget? errorIcon;
  final void Function()? onFirstButtonTap;
  final void Function()? onSecondButtonTap;
  final double? bottomPadding;

  const CustomErrorWidget({
    super.key,
    required this.errorText,
    this.firstButtonText,
    this.secondButtonText,
    this.errorIcon,
    this.onFirstButtonTap,
    this.onSecondButtonTap,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errorIcon != null) errorIcon!,
        if (errorIcon != null) const SizedBox(height: 6.0),
        Text(
          errorText,
          textAlign: TextAlign.center,
          style: CustomTextStyle.body1Medi(
            color: ColorName.gray200,
          ),
        ),
        const SizedBox(height: 18.0),
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, bottomPadding ?? 0.0),
          child: Row(
            children: [
              if (firstButtonText != null)
                Flexible(
                  child: CustomSelectButton(
                    onTap: onFirstButtonTap,
                    content: firstButtonText ?? '다시시도',
                    backgroundColor: ColorName.gray100,
                    textColor: ColorName.gray300,
                  ),
                ),
              if (firstButtonText != null && secondButtonText != null)
                const SizedBox(width: 12.0),
              if (secondButtonText != null)
                Flexible(
                  child: CustomSelectButton(
                    onTap: onSecondButtonTap,
                    content: secondButtonText ?? '새로고침',
                    backgroundColor: ColorName.gray100,
                    textColor: ColorName.gray300,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
