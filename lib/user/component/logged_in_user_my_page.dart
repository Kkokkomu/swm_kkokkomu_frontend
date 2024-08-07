import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoggedInUserMyPage extends ConsumerWidget {
  const LoggedInUserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => ref.read(userInfoProvider.notifier).logout(),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
