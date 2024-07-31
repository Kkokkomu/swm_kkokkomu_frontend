import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
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
                  child: Image.asset(
                    'assets/images/splash_icon.png',
                    width: 180,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/images/apple_login.png',
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
                          .login(SocialLoginType.KAKAO),
                      child: Image.asset(
                        'assets/images/kakao_login_medium_wide.png',
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    GestureDetector(
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
    );
  }
}
