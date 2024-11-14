import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';

class NotificationDetailScreen extends StatelessWidget {
  static String get routeName => 'notification-detail';

  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayoutWithDefaultAppBar(
      title: '알림 내용',
      child: Column(
        children: [],
      ),
    );
  }
}
