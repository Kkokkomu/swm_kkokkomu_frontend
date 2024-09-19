import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/user/component/app_info_menu_card.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';

class GuestUserMyPage extends StatelessWidget {
  const GuestUserMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppInfoMenuCard(),
          CustomMenuCard(
            content: '로그인',
            onTap: () => showLoginModalBottomSheet(context),
          ),
        ],
      ),
    );
  }
}
