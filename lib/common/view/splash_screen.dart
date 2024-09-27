import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Assets.animation.newsnackSplash.lottie(
            controller: _controller,
            onLoaded: (composition) async {
              _controller.duration = composition.duration * 0.75;
              final futureResp = _controller.forward();
              final futureAppInfo =
                  ref.read(appInfoProvider.notifier).getAppInfo();
              final appInfo = await futureAppInfo;
              await futureResp;

              // 앱 정보 요청 에러가 발생한 경우
              // 에러 다이얼로그 표시 후, 앱 종료 유도
              if (appInfo is AppInfoModelError && context.mounted) {
                showForceCheckDialog(
                  context: context,
                  content: '앱이 점검중이거나\n업데이트가 필요해요',
                  details: '업데이트를 확인해주세요',
                  checkMessage: '종료',
                  onCheck: () => SystemNavigator.pop(),
                );
                return;
              }

              // 앱에 강제 업데이트가 필요한 경우
              // 강제 업데이트 다이얼로그 표시
              if (appInfo is AppInfoModelForceUpdate && context.mounted) {
                showForceCheckDialog(
                  context: context,
                  content: '앱 업데이트가 필요해요',
                  details: '최신 버전으로 업데이트 해주세요',
                  checkMessage: '업데이트',
                  onCheck: () => launchUrl(Uri.parse(appInfo.storeUrl)),
                );
                return;
              }

              // 정상적으로 앱 정보를 받아온 경우
              // 로그인 화면으로 이동
              if (context.mounted) {
                context.go(CustomRoutePath.login);
              }
            },
          ),
        ),
      ),
    );
  }
}
