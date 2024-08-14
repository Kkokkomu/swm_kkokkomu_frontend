import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/guest_user_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/logged_in_user_shortform.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormScreen extends ConsumerWidget {
  static String get routeName => 'shortform';

  const ShortFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    if (user is UserModel) {
      return const LoggedInUserShortform();
    }

    return const GuestUserShortform();
  }
}
