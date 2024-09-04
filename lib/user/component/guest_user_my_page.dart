import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';

class GuestUserMyPage extends ConsumerWidget {
  const GuestUserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => showLoginModalBottomSheet(context, ref),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}
