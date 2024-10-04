import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isEnabled;
  final String text;
  final void Function()? onTap;

  const CustomRadioButton({
    super.key,
    required this.isEnabled,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isEnabled
                  ? Assets.icons.svg.icRadioEnabled.path
                  : Assets.icons.svg.icRadioDisabled.path,
            ),
            const SizedBox(width: 2.0),
            Text(
              text,
              style: CustomTextStyle.detail1Reg(color: ColorName.gray500),
            ),
            const SizedBox(width: 11.0),
          ],
        ),
      ),
    );
  }
}
