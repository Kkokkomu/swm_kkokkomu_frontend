import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
// import 'package:swm_kkokkomu_frontend/common/model/provider_logger_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router.dart';

void main() async {
  // 앱 최초 실행 시 secure storage 초기화
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(SharedPreferencesKeys.isFirstRun) ?? true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();
    prefs.setBool(SharedPreferencesKeys.isFirstRun, false);
  }

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Constants.kakaoNativeAppKey,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      // observers: [ProviderLoggerModel()],
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // SafeArea 를 고려한 BottomNavigationBar 높이 설정
    Constants.bottomNavigationBarHeightWithSafeArea =
        Constants.bottomNavigationBarHeight +
            MediaQuery.of(context).padding.bottom;

    return MaterialApp.router(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ColorName.blue500,
          selectionColor: ColorName.blue200,
          selectionHandleColor: ColorName.blue500,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: Constants.flavor == 'dev',
    );
  }
}
