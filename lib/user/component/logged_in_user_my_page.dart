import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoggedInUserMyPage extends ConsumerWidget {
  const LoggedInUserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => ref.read(userInfoProvider.notifier).logout(),
            child: const Text('로그아웃'),
          ),
          ElevatedButton(
            onPressed: () => context.go(CustomRoutePath.blockedUserManagement),
            child: const Text('차단 유저 관리'),
          ),
        ],
      ),
    );
  }
}
