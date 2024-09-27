import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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

void main(name, options) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 앱 최초 실행 시 secure storage 초기화
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(SharedPreferencesKeys.isFirstRun) ?? true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();
    prefs.setBool(SharedPreferencesKeys.isFirstRun, false);
  }

  // Firebase 초기화
  await Firebase.initializeApp(
    name: name,
    options: options,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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

  // debug 모드일 때만 debugPrint로 로그 출력
  if (!kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

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
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            overlayColor: ColorName.gray300,
          ),
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
