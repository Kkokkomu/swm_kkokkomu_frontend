import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_report_dialog.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/show_detail_info_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MoreInfoButton extends ConsumerWidget {
  final int newsId;
  final ShortFormReactionCountInfo reactionCountInfo;
  final ReactionType? userReactionType;

  const MoreInfoButton({
    super.key,
    required this.newsId,
    required this.reactionCountInfo,
    required this.userReactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
        size: Constants.shortFormFloatingButtonSize,
      ),
      offset: const Offset(0, Constants.shortFormFloatingButtonSize + 16.0),
      onSelected: (value) async {
        switch (value) {
          case ShortFormMoreInfoPopupType.viewDescription:
            showDetailInfoBottomSheet(
              context: context,
              ref: ref,
              newsId: newsId,
              reactionCountInfo: reactionCountInfo,
              userReactionType: userReactionType,
            );
            return;

          case ShortFormMoreInfoPopupType.nonInterested:
            // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
            if (ref.read(userInfoProvider) is! UserModel) {
              showLoginModalBottomSheet(context, ref);
              return;
            }

            // TODO : 관심없어요 처리
            return;

          case ShortFormMoreInfoPopupType.report:
            // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
            if (ref.read(userInfoProvider) is! UserModel) {
              showLoginModalBottomSheet(context, ref);
              return;
            }

            final reportType =
                await showShortFormReportDialog(context: context);

            // 신고 사유를 선택하지 않은 경우 리턴
            if (reportType == null) {
              return;
            }

            // 신고 요청
            final resp = await ref
                .read(loggedInUserShortFormProvider.notifier)
                .reportShortForm(
                  newsId: newsId,
                  reason: reportType,
                );

            // 신고 실패 시 에러 메시지 출력
            if (resp.success == false) {
              // 이미 신고한 숏폼인 경우 에러 다이얼로그 출력
              // TODO : alreadyReportedCommentCode를 사용하는 것이 맞는지 확인
              if (resp.errorCode ==
                      CustomErrorCode.alreadyReportedCommentCode &&
                  context.mounted) {
                showInfoDialog(
                  context: context,
                  content: resp.errorMessage ?? '이미 신고되었습니다.',
                );
                return;
              }

              CustomToastMessage.showErrorToastMessage('신고에 실패했습니다.');
              return;
            }

            // 신고 성공 시 성공 메시지 출력
            CustomToastMessage.showSuccessToastMessage('신고되었습니다.');

            return;

          default:
            return;
        }
      },
      itemBuilder: (_) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: ShortFormMoreInfoPopupType.viewDescription,
          child: Text('설명보기'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: ShortFormMoreInfoPopupType.nonInterested,
          child: Text('관심없어요'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: ShortFormMoreInfoPopupType.report,
          child: Text('신고하기'),
        ),
      ],
    );
  }
}
