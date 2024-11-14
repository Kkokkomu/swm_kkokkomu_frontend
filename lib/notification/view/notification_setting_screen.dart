import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/model/notification_permission_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/notification_permission_provider.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/detail_user_info_provider.dart';

class NotificationSettingScreen extends ConsumerWidget {
  static String get routeName => 'notification-setting';

  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailUser = ref.watch(detailUserInfoProvider);
    final notificationPermission = ref.watch(notificationPermissionProvider);

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      onBackButtonPressed: () => context.pop(),
      title: '알림 설정',
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (notificationPermission is NotificationPermissionDenied)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '알림 설정이 꺼져 있어요',
                      style: CustomTextStyle.head2(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '푸시 알림을 받으려면 알림 설정을 허용해주세요',
                      style: CustomTextStyle.body3Medi(
                        color: ColorName.gray500,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    CustomSelectButton(
                      onTap: () => ref
                          .read(notificationPermissionProvider.notifier)
                          .requestNotificationPermission(),
                      content: '알림 켜기',
                    ),
                  ],
                ),
              ),
            if (notificationPermission is NotificationPermissionDenied)
              Container(
                color: ColorName.gray50,
                height: 8.0,
              ),
            SizedBox(
              height: notificationPermission is NotificationPermissionDenied
                  ? 12.0
                  : 24.0,
            ),
            switch (detailUser) {
              // 유저 정보 로딩 중
              DetailUserModelLoading() => const Skeletonizer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        NotificationSettingCardSkeleton(),
                        SizedBox(height: 12.0),
                        NotificationSettingCardSkeleton(),
                        SizedBox(height: 12.0),
                        NotificationSettingCardSkeleton(),
                      ],
                    ),
                  ),
                ),

              // 유저 정보 불러오기 에러
              DetailUserModelError() => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.exclamationmark_triangle,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '알림 설정을 불러오는데 실패했어요',
                              style: CustomTextStyle.body2Reg(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18.0),
                        CustomSelectButton(
                          content: '다시 시도',
                          onTap: () => ref
                              .read(detailUserInfoProvider.notifier)
                              .getDetailUserInfo(),
                        ),
                      ],
                    ),
                  ),
                ),

              // 유저 정보 불러오기 성공
              DetailUserModel() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      NotificationSettingCard(
                        notificationSettingType: NotificationSettingType.notice,
                        isSwitchOn: detailUser.alarmInformYn,
                      ),
                      const SizedBox(height: 12.0),
                      NotificationSettingCard(
                        notificationSettingType:
                            NotificationSettingType.newArticle,
                        isSwitchOn: detailUser.alarmNewContentYn,
                      ),
                      const SizedBox(height: 12.0),
                      NotificationSettingCard(
                        notificationSettingType: NotificationSettingType.reply,
                        isSwitchOn: detailUser.alarmReplyYn,
                      ),
                    ],
                  ),
                ),
            },
          ],
        ),
      ),
    );
  }
}

class NotificationSettingCard extends ConsumerWidget {
  final bool isSwitchOn;
  final NotificationSettingType notificationSettingType;

  const NotificationSettingCard({
    super.key,
    required this.isSwitchOn,
    required this.notificationSettingType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationPermission = ref.watch(notificationPermissionProvider);

    // 알림 권한이 허용되었는지 여부
    final isNotificationPermissionGranted =
        notificationPermission is NotificationPermissionGranted;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          notificationSettingType.label,
          style: CustomTextStyle.body2Bold(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.8,
          ),
          child: SizedBox(
            width: 40.0,
            child: FittedBox(
              child: isNotificationPermissionGranted
                  ? CupertinoSwitch(
                      activeColor: ColorName.blue500,
                      trackColor: ColorName.gray100,
                      value: isSwitchOn,
                      onChanged: (value) async {
                        final resp = await ref
                            .read(detailUserInfoProvider.notifier)
                            .updateUserNotificationSetting(
                              notificationSettingType: notificationSettingType,
                              value: value,
                            );

                        // 세팅 변경 실패 시
                        if (!resp.success) {
                          CustomToastMessage.showErrorToastMessage(
                              '알림 설정 변경에 실패했어요');
                        }
                      },
                    )
                  : const CupertinoSwitch(
                      value: false,
                      onChanged: null,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationSettingCardSkeleton extends StatelessWidget {
  const NotificationSettingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'XXXXXXXXXX',
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.8,
          ),
          child: SizedBox(
            width: 40.0,
            child: FittedBox(
              child: CupertinoSwitch(
                value: false,
                onChanged: null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
