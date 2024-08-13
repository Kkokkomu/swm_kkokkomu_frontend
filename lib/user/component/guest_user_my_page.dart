import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class GuestUserMyPage extends ConsumerWidget {
  const GuestUserMyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                final userInfo = ref.watch(userInfoProvider);

                return Container(
                  color: Colors.white,
                  height: 400,
                  child: Center(
                    child: userInfo is UserModelLoading
                        ? const CircularProgressIndicator()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await ref
                                        .read(userInfoProvider.notifier)
                                        .login(SocialLoginType.apple);
                                    context.pop();
                                  },
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
                                  onTap: () async {
                                    await ref
                                        .read(userInfoProvider.notifier)
                                        .login(SocialLoginType.kakao);
                                    context.pop();
                                  },
                                  child: Image.asset(
                                    Assets.kakaoLoginButtonImage,
                                    fit: BoxFit.fitWidth,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}
