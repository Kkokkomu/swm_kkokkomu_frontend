import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final bool isRefreshable;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.isRefreshable = true,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorName.white000,
      color: ColorName.blue500,
      onRefresh: onRefresh,
      notificationPredicate:
          isRefreshable ? defaultScrollNotificationPredicate : (_) => false,
      child: child,
    );
  }
}
