import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';

class AppInfoMenuCard extends StatelessWidget {
  const AppInfoMenuCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMenuCard(
      content: '앱 정보',
      onTap: () => context.go(CustomRoutePath.appInfo),
    );
  }
}
