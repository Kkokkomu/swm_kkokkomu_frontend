import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/policy_links.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class AppInfoScreen extends ConsumerWidget {
  static String get routeName => 'info';

  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider);

    final isUpdateAvailable = appInfo is AppInfoModel &&
        Version.parse(appInfo.latestAppInfo.version) >
            Version.parse(appInfo.currentAppInfo.version);

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      title: '앱 정보',
      onBackButtonPressed: () => context.pop(),
      child: Column(
        children: [
          Container(
            height: 58,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorName.gray100,
                  width: 0.5,
                ),
              ),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 18.0),
                  Text(
                    '앱 버전',
                    style: CustomTextStyle.body2Bold(),
                  ),
                  const Spacer(),
                  Text(
                    appInfo is AppInfoModel
                        ? 'v${appInfo.currentAppInfo.version}'
                        : '',
                    style: CustomTextStyle.detail1Reg(color: ColorName.blue500),
                  ),
                  if (isUpdateAvailable) const SizedBox(width: 12.0),
                  if (isUpdateAvailable)
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () =>
                          launchUrl(Uri.parse(appInfo.latestAppInfo.url)),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: ColorName.blue100,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '업데이트',
                            style: CustomTextStyle.detail1Reg(
                              color: ColorName.blue500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: isUpdateAvailable ? 12.0 : 18.0),
                ],
              ),
            ),
          ),
          CustomMenuCard(
            content: '서비스 이용 약관',
            onTap: () => launchUrl(
              Uri.parse(PolicyLinks.termsOfService),
            ),
          ),
          CustomMenuCard(
            content: '개인 정보 처리 방침',
            onTap: () => launchUrl(
              Uri.parse(PolicyLinks.privacyPolicy),
            ),
          ),
          const SizedBox(height: 18.0),
          Row(
            children: [
              const SizedBox(width: 18.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '문의 사항',
                    style: CustomTextStyle.body2Bold(),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'kkokkomu27@gmail.com',
                    style: CustomTextStyle.detail1Reg(color: ColorName.gray300),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
