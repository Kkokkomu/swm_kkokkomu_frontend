import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/guest_user_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/logged_in_user_shortform.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortsScreen extends ConsumerStatefulWidget {
  const ShortsScreen({super.key});

  @override
  ConsumerState<ShortsScreen> createState() => _ShortScreenState();
}

class _ShortScreenState extends ConsumerState<ShortsScreen>
    with AutomaticKeepAliveClientMixin<ShortsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoProvider);

    super.build(context);

    if (user is UserModel) {
      return const LoggedInUserShortform();
    }

    return const GuestUserShortform();
  }
}
