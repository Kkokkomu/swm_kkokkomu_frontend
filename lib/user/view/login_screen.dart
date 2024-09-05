import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
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

        final resp = await showConfirmationDialog(
          context: context,
          content: '앱을 종료하시겠습니까?',
          confirmText: '종료',
          cancelText: '취소',
        );

        // 사용자가 종료를 선택했다면 앱을 종료함
        if (resp == true) {
          SystemNavigator.pop();
        }
      },
      child: DefaultLayout(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const Spacer(),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Assets.images.splashIcon.image(
                      width: 180,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: userInfo is UserModelLoading
                      ? const CustomCircularProgressIndicator()
                      : Column(
                          children: [
                            if (Platform.isIOS)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(userInfoProvider.notifier)
                                        .login(SocialLoginType.apple),
                                    child: Assets.images.appleLogin.image(
                                      fit: BoxFit.fitWidth,
                                      width: double.infinity,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                ],
                              ),
                            GestureDetector(
                              onTap: () => ref
                                  .read(userInfoProvider.notifier)
                                  .login(SocialLoginType.kakao),
                              child: Assets.images.kakaoLoginLargeWide.image(
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            GestureDetector(
                              onTap: () => ref
                                  .read(userInfoProvider.notifier)
                                  .guestLogin(),
                              child: SizedBox(
                                width: double.infinity,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    height: 54,
                                    width: 342,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Text(
                                        '비로그인으로 둘러보기',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
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
