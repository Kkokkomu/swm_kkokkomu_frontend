import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';

class NotificationSettingScreen extends StatelessWidget {
  static String get routeName => 'notification-setting';

  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      onBackButtonPressed: () => context.pop(),
      title: '알림 설정',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기기 알림이 꺼져 있어요',
                    style: CustomTextStyle.head2(),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '알림을 받으려면 기기 설정에서 알림을 허용해주세요',
                    style: CustomTextStyle.body3Medi(
                      color: ColorName.gray500,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  const CustomSelectButton(
                    content: '기기 알림 켜기',
                  ),
                ],
              ),
            ),
            Container(
              color: ColorName.gray50,
              height: 8.0,
            ),
            const SizedBox(height: 12.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  NotificationSettingCard(title: '공지사항 알림'),
                  SizedBox(height: 12.0),
                  NotificationSettingCard(title: '새 뉴스 알림'),
                  SizedBox(height: 12.0),
                  NotificationSettingCard(title: '대댓글 알림'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingCard extends StatelessWidget {
  final String title;
  final String? detail;

  const NotificationSettingCard({
    super.key,
    required this.title,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTextStyle.body2Bold(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.8,
          ),
          child: SizedBox(
            width: 40.0,
            child: FittedBox(
              child: CupertinoSwitch(
                activeColor: ColorName.blue500,
                trackColor: ColorName.gray100,
                onLabelColor: CupertinoColors.activeOrange,
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
