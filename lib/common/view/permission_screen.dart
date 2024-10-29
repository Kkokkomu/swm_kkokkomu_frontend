import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';

class PermissionScreen extends ConsumerWidget {
  static String get routeName => 'permission';

  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: ColorName.white000,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 76.0),
              Text(
                '앱 사용을 위해\n접근 권한을 허용해주세요',
                style: CustomTextStyle.head2(),
              ),
              const SizedBox(height: 32.0),
              Text(
                '선택 권한',
                style: CustomTextStyle.body2Medi(color: ColorName.gray500),
              ),
              const SizedBox(height: 24.0),
              PermissionCard(
                prefixIcon: Assets.icons.svg.icAlarm.svg(
                  width: 23.0,
                ),
                title: '알림',
                description: '알림 메시지 발송시 필요해요',
              ),
              const SizedBox(height: 18.0),
              PermissionCard(
                prefixIcon: Assets.icons.svg.icPhoto.svg(
                  width: 23.0,
                ),
                title: '사진',
                description: '프로필 사진 적용시 필요해요',
              ),
              const SizedBox(height: 18.0),
              PermissionCard(
                prefixIcon: Assets.icons.svg.icCamera.svg(
                  width: 23.0,
                ),
                title: '카메라',
                description: '프로필 사진 촬영시 필요해요',
              ),
              const SizedBox(height: 40.0),
              const Divider(
                color: ColorName.gray200,
                thickness: 0.5,
                height: 0.5,
              ),
              const SizedBox(height: 24.0),
              Text(
                '선택 권한의 경우 허용하지 않아도 서비스를 사용할 수 있으나\n일부 서비스 이용이 제한될 수 있습니다.',
                style: CustomTextStyle.detail1Reg(color: ColorName.gray300),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CustomSelectButton(
                  onTap: () async {
                    await ref
                        .read(pushNotificationServiceProvider)
                        .requestPermission();

                    // 권한 체크 완료 후, 로그인 화면으로 이동
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool(
                      SharedPreferencesKeys.isPermissionChecked,
                      true,
                    );

                    if (context.mounted) {
                      context.go(CustomRoutePath.login);
                    }
                  },
                  content: '확인',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionCard extends StatelessWidget {
  final Widget prefixIcon;
  final String title;
  final String description;

  const PermissionCard({
    super.key,
    required this.prefixIcon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        prefixIcon,
        const SizedBox(width: 8.0),
        Text(
          title,
          style: CustomTextStyle.body2Bold(color: ColorName.gray500),
        ),
        const SizedBox(width: 18.0),
        Flexible(
          child: Text(
            description,
            style: CustomTextStyle.detail1Reg(color: ColorName.gray200),
          ),
        ),
      ],
    );
  }
}
