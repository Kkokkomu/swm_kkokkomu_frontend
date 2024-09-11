import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';

class GuestUserMyPage extends StatelessWidget {
  const GuestUserMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => showLoginModalBottomSheet(context),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}
