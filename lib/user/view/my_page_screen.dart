import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/component/guest_user_my_page.dart';
import 'package:swm_kkokkomu_frontend/user/component/logged_in_user_my_page.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyPageScreen extends ConsumerWidget {
  static String get routeName => 'mypage';

  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    if (userInfo is UserModel) {
      return LoggedInUserMyPage(userInfo: userInfo);
    }

    return const GuestUserMyPage();
  }
}
