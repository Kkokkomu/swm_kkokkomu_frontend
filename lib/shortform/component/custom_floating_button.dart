import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomFloatingButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final Color labelColor;
  final void Function()? onTap;
  final bool shadowEnabled;
  final double? width;
  final double? height;
  final bool isInkWell;
  final bool isTextShadowEnabled;

  const CustomFloatingButton({
    super.key,
    required this.icon,
    this.label,
    this.labelColor = ColorName.white000,
    required this.onTap,
    this.shadowEnabled = true,
    this.width,
    this.height,
    this.isInkWell = true,
    this.isTextShadowEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: isInkWell ? null : Colors.transparent,
        highlightColor: isInkWell ? null : Colors.transparent,
        hoverColor: isInkWell ? null : Colors.transparent,
        customBorder: const CircleBorder(),
        child: Container(
          width: width,
          height: height,
          decoration: shadowEnabled
              ? BoxDecoration(
                  // 하얀 배경에서도 아이콘이 잘 보일 수 있도록 그림자 추가
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                    ),
                  ],
                )
              : null,
          // width와 height가 모두 null인 경우에는 Center로 감싸지 않음
          child: width == null && height == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    if (label != null)
                      Text(
                        label!,
                        style: CustomTextStyle.detail3Reg(color: labelColor),
                      ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      if (label != null)
                        Text(
                          label!,
                          style: CustomTextStyle.detail3Reg(
                            color: labelColor,
                            shadows: isTextShadowEnabled
                                ? [
                                    const Shadow(
                                      color: Colors.black,
                                      blurRadius: 16.0,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
