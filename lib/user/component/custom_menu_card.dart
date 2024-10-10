import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomMenuCard extends StatelessWidget {
  final String content;
  final Widget? prefixIcon;
  final bool isEnterIcon;
  final void Function()? onTap;

  const CustomMenuCard({
    super.key,
    required this.content,
    this.prefixIcon,
    this.isEnterIcon = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorName.gray100,
              width: 0.5,
            ),
          ),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 18.0),
              if (prefixIcon != null) prefixIcon!,
              if (prefixIcon != null) const SizedBox(width: 18.0),
              Text(
                content,
                style: CustomTextStyle.body2Bold(),
              ),
              if (isEnterIcon) const Spacer(),
              if (isEnterIcon) Assets.icons.svg.btnEnter.svg(),
              if (isEnterIcon) const SizedBox(width: 4.0)
            ],
          ),
        ),
      ),
    );
  }
}
