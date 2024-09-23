import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      appInfoProvider,
      (previous, next) {
        // 상태가 변경되지 않은 경우 무시
        if (previous == next) {
          return;
        }

        // 강제 업데이트가 필요한 경우 다이얼로그 표시
        if (next is AppInfoModelForceUpdate) {
          showForceCheckDialog(
            context: context,
            content: '앱 업데이트가 필요해요',
            details: '최신 버전으로 업데이트 해주세요',
            checkMessage: '업데이트',
            onCheck: () => launchUrl(Uri.parse(next.storeUrl)),
          );
        }

        // 에러가 발생한 경우 앱 실행 중단
        if (next is AppInfoModelError) {
          showForceCheckDialog(
            context: context,
            content: '앱이 점검중이에요',
            details: '잠시 후 다시 접속해주세요',
            checkMessage: '종료',
            onCheck: () => SystemNavigator.pop(),
          );
        }
      },
    );

    return DefaultLayout(
      statusBarBrightness: Brightness.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorName.splashGradationStart,
              ColorName.splashGradationEnd,
            ],
          ),
        ),
        child: Center(
          child: Assets.icons.svg.splashLogo.svg(),
        ),
      ),
    );
  }
}
