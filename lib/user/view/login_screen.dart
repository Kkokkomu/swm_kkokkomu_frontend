import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    // 로그인 에러시 토스트 메시지 띄우기
    if (userInfo is UserModelError) {
      Fluttertoast.showToast(
        msg: '${userInfo.message}\n다시 시도해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

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
                    Assets.splashIcon,
                    width: 180,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: userInfo is UserModelLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () => ref
                                .read(userInfoProvider.notifier)
                                .login(SocialLoginType.apple),
                            child: Image.asset(
                              Assets.appleLoginButtonImage,
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
                                .login(SocialLoginType.kakao),
                            child: Image.asset(
                              Assets.kakaoLoginButtonImage,
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
    );
  }
}