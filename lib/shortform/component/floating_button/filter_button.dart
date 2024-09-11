import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.tune,
        color: Colors.white,
      ),
      // TODO : 현재 로그인 상태만 필터화면으로 이동하도록 함. 비로그인 유저도 필터링 가능하게 할 건지 결정해야 함.
      onTap: () {
        // 로그인 상태가 아닌 경우 로그인 모달창 띄우기
        if (ref.read(userInfoProvider) is! UserModel) {
          showLoginModalBottomSheet(context);
          return;
        }

        // 로그인 상태인 경우 필터화면으로 이동
        context.go(CustomRoutePath.filter);
      },
    );
  }
}
