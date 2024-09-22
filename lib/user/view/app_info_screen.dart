import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoScreen extends ConsumerWidget {
  static String get routeName => 'info';

  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider);

    return DefaultLayout(
      statusBarBrightness: Brightness.dark,
      appBarHeight: 48.0,
      titleWidget: Text(
        '앱 정보',
        style: CustomTextStyle.head4(),
      ),
      centerTitle: true,
      titleLeading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.pop(),
          child: Assets.icons.svg.btnBack.svg(),
        ),
      ),
      titleLeadingWidth: 48.0,
      appBarBottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: ColorName.gray100,
          height: 0.5,
        ),
      ),
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
                    appInfo.when(
                      data: (data) => 'v${data.version}',
                      loading: () => '',
                      error: (_, __) => '',
                    ),
                    style: CustomTextStyle.detail1Reg(color: ColorName.blue500),
                  ),
                  const SizedBox(width: 18.0)
                ],
              ),
            ),
          ),
          CustomMenuCard(
            content: '서비스 이용 약관',
            onTap: () => launchUrl(
              Uri.parse(
                  'https://wooded-crib-541.notion.site/1-0-0ver-106908e7bbc5806dac39caf5ebc3dee4?pvs=4'),
            ),
          ),
          CustomMenuCard(
            content: '개인 정보 처리 방침',
            onTap: () => launchUrl(
              Uri.parse(
                  'https://wooded-crib-541.notion.site/1-0-0ver-105908e7bbc58012b04ef2df397d0cff?pvs=4'),
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
