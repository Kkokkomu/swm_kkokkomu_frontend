import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_detail_model.dart';
import 'package:swm_kkokkomu_frontend/notification/provider/notification_detail_provider.dart';

class NotificationDetailScreen extends ConsumerWidget {
  static String get routeName => 'notification-detail';

  final int notificationId;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationDetail =
        ref.watch(notificationDetailProvider(notificationId));

    return DefaultLayoutWithDefaultAppBar(
      onBackButtonPressed: () => context.pop(),
      title: '공지사항',
      child: switch (notificationDetail) {
        // 공지사항 상세 정보 로딩 중
        NotificationDetailModelLoading() => const Center(
            child: CustomCircularProgressIndicator(),
          ),

        // 공지사항 상세 정보 에러
        NotificationDetailModelError() => SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.svg.imgNoticeEmpty.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '공지사항을 불러오는데 실패했어요',
                    style: CustomTextStyle.body1Medi(
                      color: ColorName.gray200,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomSelectButton(
                      onTap: () => ref
                          .read(notificationDetailProvider(notificationId)
                              .notifier)
                          .getNotificationDetailInfo(),
                      content: '재시도',
                      backgroundColor: ColorName.gray100,
                      textColor: ColorName.gray300,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 공지사항 상세 정보를 성공적으로 불러왔을 때
        NotificationDetailModel() => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationDetail.title,
                    style: CustomTextStyle.head4(),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    notificationDetail.editedAt.year ==
                            Constants.unknownErrorDateTimeYear
                        ? Constants.unknownErrorString
                        : DateFormat('yyyy.MM.dd a hh:mm', 'ko_KR')
                            .format(notificationDetail.editedAt),
                    style: CustomTextStyle.detail3Reg(
                      color: ColorName.gray300,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    color: ColorName.gray100,
                    height: 0.5,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    notificationDetail.body,
                    style: CustomTextStyle.body2Reg(),
                  ),
                ],
              ),
            ),
          ),
      },
    );
  }
}
