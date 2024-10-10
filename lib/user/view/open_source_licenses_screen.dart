import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/fonts.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';

class OpenSourceLicensesScreen extends ConsumerWidget {
  static String get routeName => 'open-source-licenses';

  const OpenSourceLicensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider);

    return DefaultLayout(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      child: Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: ColorName.white000,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            titleTextStyle: CustomTextStyle.head4(),
          ),
          fontFamily: FontFamily.pretendard,
          cardColor: ColorName.white000,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Scrollbar(
            child: LicensePage(
              applicationIcon: Assets.icons.svg.appIcon.svg(),
              applicationName:
                  appInfo is AppInfoModel ? appInfo.currentAppInfo.appName : '',
              applicationVersion:
                  appInfo is AppInfoModel ? appInfo.currentAppInfo.version : '',
              applicationLegalese: 'This application is Copyright © 2024 KKM.\n'
                  'All rights reserved.\n\n'
                  'The following sets forth attribution notices for third party software that may be contained in this application.\n\n'
                  'If you have any questions about these notices,\n'
                  'please email us at kkokkomu27@gmail.com',
            ),
          ),
        ),
      ),
    );
  }
}
