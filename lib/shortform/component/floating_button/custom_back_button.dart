import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: Assets.icons.svg.btnBack.svg(
        width: 48.0,
        height: 48.0,
        colorFilter: const ColorFilter.mode(
          ColorName.white000,
          BlendMode.srcIn,
        ),
      ),
      onTap: () => context.pop(),
    );
  }
}
