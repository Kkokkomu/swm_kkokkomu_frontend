import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

Future<dynamic> showLoginModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) => Consumer(
      builder: (_, ref, __) {
        ref.listen(
          userInfoProvider,
          (_, next) {
            if (next is UserModel) {
              context.pop();
            }
          },
        );
        final userInfo = ref.watch(userInfoProvider);

        return Container(
          height: 444.0,
          decoration: const BoxDecoration(
            color: ColorName.white000,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5.5),
              const CustomGrabber(),
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: CustomCloseButton(),
                ),
              ),
              Assets.icons.svg.imgLoginEmpty.svg(),
              const SizedBox(height: 4.0),
              Text(
                textAlign: TextAlign.center,
                '로그인 후,\n모든 기능을 이용해 보세요!',
                style: CustomTextStyle.head3(),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 68.0,
                    height: 1.0,
                    color: ColorName.gray100,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'SNS 계정으로 로그인하기',
                    style: CustomTextStyle.body3Medi(color: ColorName.gray200),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: 68.0,
                    height: 1.0,
                    color: ColorName.gray100,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              userInfo is UserModelLoading
                  ? const Center(
                      child: CustomCircularProgressIndicator(
                        color: ColorName.gray400,
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
                            child: Assets.icons.png.loginApple3x.image(
                              width: 60.0,
                              cacheWidth: (60.0 *
                                      MediaQuery.of(context).devicePixelRatio)
                                  .round(),
                            ),
                          ),
                        if (Platform.isIOS) const SizedBox(width: 24.0),
                        GestureDetector(
                          onTap: () => ref
                              .read(userInfoProvider.notifier)
                              .login(SocialLoginType.google),
                          child: Assets.icons.png.loginGoogle3x.image(
                            width: 60.0,
                            cacheWidth:
                                (60.0 * MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        GestureDetector(
                          onTap: () => ref
                              .read(userInfoProvider.notifier)
                              .login(SocialLoginType.kakao),
                          child: Assets.icons.png.loginKakao3x.image(
                            width: 60.0,
                            cacheWidth:
                                (60.0 * MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    ),
  );
}
