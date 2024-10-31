import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/app_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
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

  // 스플래시 스크린에서 앱 정보를 받아온 후, 다음 화면으로 이동
  Future<void> fetchAppInfoAndRoute() async {
    _controller.reset();
    final futureResp = _controller.forward();
    final futurePrefs = SharedPreferences.getInstance();
    final appInfo = await ref.read(appInfoProvider.notifier).getAppInfo();
    if (appInfo is AppInfoModel) {
      // 앱 상태가 정상인 경우에만
      // 로그인 정보를 받아오기 위해 사용자 정보 요청
      await ref.read(userInfoProvider.notifier).getUserInfo();

      // 로그인 정보를 받아온 후, fcm 서비스 초기화
      await ref.read(pushNotificationServiceProvider).initializeNotification();
    }
    final prefs = await futurePrefs;
    await futureResp;

    switch (appInfo) {
      case AppInfoModelLoading() || AppInfoModelError():
        // 앱 정보 요청 에러가 발생한 경우
        // 에러 다이얼로그 표시 후, 앱 종료 혹은 재시도 유도
        if (mounted) {
          showForceCheckDialog(
            context: context,
            content: '서버와 통신 중 문제가 발생했어요\n\n인터넷 상태와 앱 업데이트를\n확인해주세요',
            checkMessage: Platform.isAndroid ? '종료' : '다시시도',
            onCheck: () {
              context.pop();
              Platform.isAndroid
                  ? SystemNavigator.pop()
                  : fetchAppInfoAndRoute();
            },
          );
        }
        return;

      case AppInfoModelOffline():
        // 서버가 오프라인 상태인 경우
        // 오프라인 다이얼로그 표시 후, 앱 종료 유도
        if (mounted) {
          showForceCheckDialog(
            context: context,
            content: appInfo.offlineMessage,
            details: appInfo.detailedOfflineMessage,
            checkMessage: Platform.isAndroid ? '종료' : '다시시도',
            onCheck: () {
              context.pop();
              Platform.isAndroid
                  ? SystemNavigator.pop()
                  : fetchAppInfoAndRoute();
            },
          );
        }
        return;

      case AppInfoModelForceUpdate():
        // 앱에 강제 업데이트가 필요한 경우
        // 강제 업데이트 다이얼로그 표시
        if (mounted) {
          showForceCheckDialog(
            context: context,
            content: '앱 업데이트가 필요해요',
            details: '최신 버전으로 업데이트 해주세요',
            checkMessage: '업데이트',
            onCheck: () => launchUrl(Uri.parse(appInfo.storeUrl)),
          );
        }
        return;

      case AppInfoModel():
        // 정상적으로 앱 정보를 받아온 경우
        if (mounted) {
          // 앱 권한 확인을 완료한 경우
          // 로그인 화면으로 이동
          if (prefs.getBool(SharedPreferencesKeys.isPermissionChecked) ??
              false) {
            context.go(CustomRoutePath.login);
            return;
          }

          // 앱 권한을 아직 확인하지 않은 경우
          // 권한 확인 화면으로 이동
          context.go(CustomRoutePath.permission);
        }
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: ColorName.splashGradationEnd,
      systemNavigationBarIconBrightness: Brightness.light,
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
            onLoaded: (composition) {
              _controller.duration = composition.duration * 0.8;
              fetchAppInfoAndRoute();
            },
          ),
        ),
      ),
    );
  }
}
