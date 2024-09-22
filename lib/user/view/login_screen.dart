import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        // 사용자가 종료를 선택했다면 앱 종료 다이얼로그를 띄움
        showAppExitDialog(context);
      },
      child: DefaultLayout(
        statusBarBrightness: Brightness.light,
        child: Container(
          width: double.infinity,
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '쉽고 짧은 뉴스 플랫폼',
                  style: CustomTextStyle.head4(color: ColorName.white000),
                ),
                const SizedBox(height: 24.0),
                Assets.icons.svg.splashLogo.svg(),
                Assets.icons.svg.splashTypoLogo.svg(),
                const SizedBox(height: 90.0),
                userInfo is UserModelLoading
                    ? const SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomCircularProgressIndicator(
                            color: ColorName.gray400,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Platform.isIOS)
                            GestureDetector(
                              onTap: () => ref
                                  .read(userInfoProvider.notifier)
                                  .login(SocialLoginType.apple),
                              child: Assets.icons.png.loginApple3x
                                  .image(width: 60.0),
                            ),
                          if (Platform.isIOS) const SizedBox(width: 24.0),
                          GestureDetector(
                            onTap: () => ref
                                .read(userInfoProvider.notifier)
                                .login(SocialLoginType.google),
                            child: Assets.icons.png.loginGoogle3x
                                .image(width: 60.0),
                          ),
                          const SizedBox(width: 24.0),
                          GestureDetector(
                            onTap: () => ref
                                .read(userInfoProvider.notifier)
                                .login(SocialLoginType.kakao),
                            child: Assets.icons.png.loginKakao3x
                                .image(width: 60.0),
                          ),
                        ],
                      ),
                const SizedBox(height: 5.0),
                if (userInfo is! UserModelLoading)
                  TextButton(
                    onPressed: () =>
                        ref.read(userInfoProvider.notifier).guestLogin(),
                    child: Text(
                      '로그인 없이 둘러보기',
                      style: CustomTextStyle.detail1Reg(
                        color: ColorName.blue100,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorName.blue100,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
