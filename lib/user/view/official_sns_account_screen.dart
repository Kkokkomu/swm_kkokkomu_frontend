import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/in_app_links.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/user/component/custom_menu_card.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficialSnsAccountScreen extends StatelessWidget {
  static String get routeName => 'official-sns-account';

  const OfficialSnsAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      title: '공식 SNS 계정',
      onBackButtonPressed: () => context.pop(),
      child: Column(
        children: [
          CustomMenuCard(
            prefixIcon: Assets.icons.png.youtubeSocialIconRed.image(
              width: 40.0,
              cacheWidth:
                  (40.0 * MediaQuery.of(context).devicePixelRatio).round(),
            ),
            content: '공식 유튜브 계정',
            onTap: () => launchUrl(
              Uri.parse(InAppLinks.youtubeChannel),
            ),
          ),
          CustomMenuCard(
            prefixIcon: Assets.icons.png.instagramGlyphGradient.image(
              width: 40.0,
              cacheWidth:
                  (40.0 * MediaQuery.of(context).devicePixelRatio).round(),
            ),
            content: '공식 인스타그램 계정',
            onTap: () => launchUrl(
              Uri.parse(InAppLinks.instagram),
            ),
          ),
          CustomMenuCard(
            prefixIcon: Assets.icons.png.tikTokIconBlackCircle.image(
              width: 40.0,
              cacheWidth:
                  (40.0 * MediaQuery.of(context).devicePixelRatio).round(),
            ),
            content: '공식 틱톡 계정',
            onTap: () => launchUrl(
              Uri.parse(InAppLinks.tiktok),
            ),
          ),
        ],
      ),
    );
  }
}
