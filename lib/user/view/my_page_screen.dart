import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/component/guest_user_my_page.dart';
import 'package:swm_kkokkomu_frontend/user/component/logged_in_user_my_page.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPageScreen>
    with AutomaticKeepAliveClientMixin<MyPageScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);

    super.build(context);

    if (userInfo is UserModel) {
      return const LoggedInUserMyPage();
    }

    return const GuestUserMyPage();
  }
}
