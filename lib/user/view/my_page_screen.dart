import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage>
    with AutomaticKeepAliveClientMixin<MyPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userInfo = ref.watch(userInfoProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text((userInfo as UserModel).id),
      ],
    );
  }
}
