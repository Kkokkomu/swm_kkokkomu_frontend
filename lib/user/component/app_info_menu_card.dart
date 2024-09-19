import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';

class AppInfoMenuCard extends StatelessWidget {
  const AppInfoMenuCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomMenuCard(content: '앱 정보');
  }
}
