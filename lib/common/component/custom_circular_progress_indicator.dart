import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/app_colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;

  const CustomCircularProgressIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? AppColors.gray500,
    );
  }
}
