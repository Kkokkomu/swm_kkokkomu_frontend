import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/my_view_log_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/cursor_pagination_shortform_view.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_shortform_base.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyViewLogShortFormScreen extends ConsumerWidget {
  static String get routeName => 'my-view-log-shortform';

  final int initialPageIndex;

  const MyViewLogShortFormScreen({
    super.key,
    this.initialPageIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    if (user is! UserModel) {
      return const CustomShortFormBase(
        shortFormScreenType: ShortFormScreenType.myViewLog,
        child: SizedBox(),
      );
    }

    return CursorPaginationShortFormView(
      shortFormScreenType: ShortFormScreenType.myViewLog,
      initialPageIndex: initialPageIndex,
      provider: myViewLogProvider,
    );
  }
}
