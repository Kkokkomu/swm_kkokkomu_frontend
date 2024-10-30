import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/component/notification_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/in_app_links.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/user/component/app_info_menu_card.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';
import 'package:swm_kkokkomu_frontend/user/component/my_page_event_banner.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoggedInUserMyPage extends ConsumerWidget {
  final UserModel userInfo;

  const LoggedInUserMyPage({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
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
                const NotificationButton(),
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
                  const SizedBox(height: 19.0),
                ],
              ),
            ),
            Container(
              color: ColorName.gray50,
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 88,
                    fit: FlexFit.tight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () => context.go(CustomRoutePath.myViewLog),
                      child: SizedBox(
                        height: 82.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.svg.icMylogClock.svg(
                              height: 24.0,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '시청기록',
                              style: CustomTextStyle.detail1Reg(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Flexible(
                    flex: 38,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  Flexible(
                    flex: 88,
                    fit: FlexFit.tight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () => context.go(CustomRoutePath.myCommentLog),
                      child: SizedBox(
                        height: 82.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.svg.icMylogComment.svg(
                              height: 24.0,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '내 댓글',
                              style: CustomTextStyle.detail1Reg(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Flexible(
                    flex: 38,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  Flexible(
                    flex: 88,
                    fit: FlexFit.tight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () => context.go(CustomRoutePath.myReactionLog),
                      child: SizedBox(
                        height: 82.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.svg.icMylogEmotion.svg(
                              height: 24.0,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '내 반응',
                              style: CustomTextStyle.detail1Reg(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            const MyPageEventBanner(),
            const SizedBox(height: 18.0),
            Container(
              color: ColorName.gray50,
              height: 8.0,
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
                CustomMenuCard(
                  content: '문의하기',
                  onTap: () => launchUrl(
                    Uri.parse(InAppLinks.channelTalk),
                  ),
                ),
                const AppInfoMenuCard(),
                CustomMenuCard(
                  content: '로그아웃',
                  isEnterIcon: false,
                  onTap: () async {
                    final resp = await showConfirmationDialog(
                      context: context,
                      content: '로그아웃 하시겠어요?',
                      confirmText: '로그아웃',
                      cancelText: '취소',
                    );

                    if (resp == true) {
                      ref.read(userInfoProvider.notifier).logout();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
