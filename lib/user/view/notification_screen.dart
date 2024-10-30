import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  static String get routeName => 'notification';

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      onBackButtonPressed: () => context.pop(),
      isBottomBorderVisible: false,
      title: '알림',
      titleActions: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.go(CustomRoutePath.notificationSetting),
          child: Assets.icons.svg.btnSetting.svg(),
        ),
        const SizedBox(width: 4.0),
      ],
      child: Column(
        children: [
          Ink(
            color: ColorName.gray50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '기기 알림이 꺼져 있어요',
                          style: CustomTextStyle.body2Bold(),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '알림을 받으려면 기기 설정에서\n알림을 허용해주세요',
                          style: CustomTextStyle.detail1Reg(
                            color: ColorName.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Ink(
                    decoration: BoxDecoration(
                      color: ColorName.gray600,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          '알림 켜기',
                          style: CustomTextStyle.detail1Reg(
                            color: ColorName.white000,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  height: 50.0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorName.gray500,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '일반 알림',
                      style: CustomTextStyle.body2Bold(),
                    ),
                  ),
                ),
              ),
              // Flexible(
              //   flex: 1,
              //   fit: FlexFit.tight,
              //   child: Container(
              //     height: 50.0,
              //     decoration: const BoxDecoration(
              //       border: Border(
              //         bottom: BorderSide(
              //           color: ColorName.gray500,
              //           width: 1.5,
              //         ),
              //       ),
              //     ),
              //     child: Center(
              //       child: Text(
              //         '키워드 알림',
              //         style: CustomTextStyle.body2Bold(),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.svg.imgNoticeEmpty.svg(),
                    const SizedBox(height: 6.0),
                    Text(
                      '새로운 알림이 없어요',
                      style: CustomTextStyle.body1Medi(
                        color: ColorName.gray200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
