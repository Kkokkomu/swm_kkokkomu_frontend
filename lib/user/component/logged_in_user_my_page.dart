import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/user/component/app_info_menu_card.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoggedInUserMyPage extends ConsumerWidget {
  final UserModel userInfo;

  const LoggedInUserMyPage({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.go(CustomRoutePath.profile),
                child: Assets.icons.svg.btnSetting.svg(),
              ),
              Assets.icons.svg.btnNoticeDefault.svg(),
              const SizedBox(width: 4.0),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요',
                  style: CustomTextStyle.head2(),
                ),
                const SizedBox(height: 3.0),
                Text(
                  '${userInfo.nickname} 님',
                  style: CustomTextStyle.head2(),
                ),
                const SizedBox(height: 5.0),
                Text(
                  userInfo.email,
                  style: CustomTextStyle.body2Reg(
                    color: const Color(0xFF6E7291),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomMenuCard(
                content: '차단 목록',
                onTap: () => context.go(
                  CustomRoutePath.blockedUserManagement,
                ),
              ),
              const AppInfoMenuCard(),
              CustomMenuCard(
                content: '로그아웃',
                isEnterIcon: false,
                onTap: () => ref.read(userInfoProvider.notifier).logout(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
