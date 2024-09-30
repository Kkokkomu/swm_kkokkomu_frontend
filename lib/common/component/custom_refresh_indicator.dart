import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorName.white000,
      color: ColorName.blue500,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
