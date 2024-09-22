import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.pop(),
        child: Assets.icons.svg.btnClose.svg(),
      ),
    );
  }
}
