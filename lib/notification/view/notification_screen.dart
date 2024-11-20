import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_list_view_by_provider.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_error_widget.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/model/notification_permission_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/notification_permission_provider.dart';
import 'package:swm_kkokkomu_frontend/notification/component/notification_log_card.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_log_model.dart';
import 'package:swm_kkokkomu_frontend/notification/provider/notification_log_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static String get routeName => 'notification';

  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 foreground로 돌아올 때마다 알림 권한을 다시 확인
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref
            .read(notificationPermissionProvider.notifier)
            .fetchNotificationPermission(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationPermission = ref.watch(notificationPermissionProvider);

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
          if (notificationPermission is NotificationPermissionDenied)
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
                            '알림 설정이 꺼져 있어요',
                            style: CustomTextStyle.body2Bold(),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '푸시 알림을 받으려면\n알림 설정을 허용해주세요',
                            style: CustomTextStyle.detail1Reg(
                              color: ColorName.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () => ref
                          .read(notificationPermissionProvider.notifier)
                          .requestNotificationPermission(),
                      child: Ink(
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
                    ),
                  ],
                ),
              ),
            ),
          // Row(
          //   children: [
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
          //         '일반 알림',
          //         style: CustomTextStyle.body2Bold(),
          //       ),
          //     ),
          //   ),
          // ),
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
          //   ],
          // ),
          Expanded(
            child: CursorPaginationListViewByProvider<NotificationLogModel>(
              provider: notificationLogProvider,
              separatorBuilder: (_, __) => const SizedBox(height: 4.0),
              itemBuilder: (_, index, model) => Padding(
                padding: EdgeInsets.fromLTRB(
                  4.0,
                  index == 0 ? 4.0 : 0.0,
                  0.0,
                  0.0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: () {
                    final notificationType = model.alarmType;

                    switch (notificationType) {
                      // 알림 타입이 공지사항인 경우, 공지사항 화면으로 이동
                      case NotificationLogType.notice:
                        context.go(
                          CustomRoutePath.notificationDetail,
                          extra: model.notification?.id,
                        );
                        return;

                      // 알림 타입이 대댓글인 경우, 해당 대댓글이 달린 숏폼 화면으로 이동
                      case NotificationLogType.reply:
                        context.go(
                          CustomRoutePath.notificationShortForm,
                          extra: {
                            GoRouterExtraKeys.newsId: model.reply?.newsId,
                            GoRouterExtraKeys.shortFormUrl: model.shortFormUrl,
                          },
                        );
                        return;

                      case _:
                        return;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 18.0, 18.0, 18.0),
                    child: NotificationLogCard(
                      notificationLog: model,
                    ),
                  ),
                ),
              ),
              emptyWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.svg.imgNoticeEmpty.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '새로운 알림이 없어요',
                    style: CustomTextStyle.body1Medi(color: ColorName.gray200),
                  ),
                ],
              ),
              errorWidget: Center(
                child: CustomErrorWidget(
                  errorIcon: Assets.images.svg.imgNoticeEmpty.svg(),
                  errorText: '알림을 불러오는 중 오류가 발생했어요',
                  firstButtonText: '알림 다시 불러오기',
                  onFirstButtonTap: () => ref
                      .read(notificationLogProvider.notifier)
                      .paginate(forceRefetch: true),
                ),
              ),
              fetchingMoreErrorWidget: CustomErrorWidget(
                errorText: '알림을 더 불러오는 중 오류가 발생했어요',
                firstButtonText: '더 불러오기',
                secondButtonText: '새로고침',
                onFirstButtonTap: () => ref
                    .read(notificationLogProvider.notifier)
                    .paginate(fetchMore: true),
                onSecondButtonTap: () => ref
                    .read(notificationLogProvider.notifier)
                    .paginate(forceRefetch: true),
                bottomPadding: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
