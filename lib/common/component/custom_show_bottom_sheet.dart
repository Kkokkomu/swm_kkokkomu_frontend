import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

Future<dynamic> showLoginModalBottomSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      final userInfo = ref.watch(userInfoProvider);

      return Container(
        color: Colors.white,
        height: 400,
        child: Center(
          child: userInfo is UserModelLoading
              ? const CustomCircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (Platform.isIOS)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ref
                                    .read(userInfoProvider.notifier)
                                    .login(SocialLoginType.apple);

                                if (context.mounted &&
                                    ref.read(userInfoProvider) is UserModel) {
                                  context.pop();
                                }
                              },
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
                        onTap: () async {
                          await ref
                              .read(userInfoProvider.notifier)
                              .login(SocialLoginType.kakao);

                          if (context.mounted &&
                              ref.read(userInfoProvider) is UserModel) {
                            context.pop();
                          }
                        },
                        child: Assets.images.kakaoLoginLargeWide.image(
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
  );
}
