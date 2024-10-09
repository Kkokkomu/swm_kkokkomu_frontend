import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

class CustomTextFormFieldClearButton extends StatelessWidget {
  final TextEditingController? controller;

  const CustomTextFormFieldClearButton({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => controller?.clear(),
        child: Assets.icons.svg.btnDelete.svg(),
      ),
    );
  }
}
