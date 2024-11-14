import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_log_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationLogCard extends StatelessWidget {
  final NotificationLogModel notificationLog;

  const NotificationLogCard({
    super.key,
    required this.notificationLog,
  });

  @override
  Widget build(BuildContext context) {
    final notificationType = notificationLog.alarmType;

    switch (notificationType) {
      // 알림 타입이 공지사항인 경우, 공지사항 알림을 보여줌
      case NotificationLogType.notice:
        final notificationInfo = notificationLog.notification;

        // 알림 타입이 공지사항인데, 공지사항 정보가 없는 경우, 아무것도 보여주지 않음
        if (notificationInfo == null) {
          return const SizedBox();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: notificationLog.isRead
                  ? Assets.icons.svg.btnNoticeDefault.svg()
                  : Assets.icons.svg.btnNoticeNew.svg(),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationInfo.title,
                    style: CustomTextStyle.body2Medi(),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    notificationInfo.body,
                    style: CustomTextStyle.detail1Reg(
                      color: ColorName.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18.0),
            Text(
              timeago.format(notificationInfo.editedAt, locale: 'ko'),
              style: CustomTextStyle.detail2Reg(
                color: ColorName.gray200,
              ),
            ),
          ],
        );

      // 알림 타입이 대댓글인 경우, 대댓글 알림을 보여줌
      case NotificationLogType.reply:
        final replyInfo = notificationLog.reply;

        // 알림 타입이 대댓글인데, 대댓글 정보가 없는 경우, 아무것도 보여주지 않음
        if (replyInfo == null) {
          return const SizedBox();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: notificationLog.isRead
                  ? Assets.icons.svg.btnNoticeDefault.svg()
                  : Assets.icons.svg.btnNoticeNew.svg(),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '대댓글이 등록되었어요!',
                    style: CustomTextStyle.body2Medi(),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    replyInfo.content,
                    style: CustomTextStyle.detail1Reg(
                      color: ColorName.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18.0),
            Text(
              timeago.format(replyInfo.editedAt, locale: 'ko'),
              style: CustomTextStyle.detail2Reg(
                color: ColorName.gray200,
              ),
            ),
          ],
        );

      // 그 외의 타입은 알림을 보여주지 않음
      case _:
        return const SizedBox();
    }
  }
}
