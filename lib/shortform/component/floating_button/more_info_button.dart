import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_report_dialog.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/show_detail_info_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_info_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_detail_info_box_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class MoreInfoButton extends ConsumerWidget {
  final bool isLoggedInUser;
  final int newsId;

  const MoreInfoButton({
    super.key,
    required this.isLoggedInUser,
    required this.newsId,
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
            // 상세 정보 버튼 누르면
            // 상세 정보 박스가 열려있는 상태로 변경
            // 플로팅 버튼 숨김
            // 바텀 네비게이션바 숨김
            ref
                .read(shortFormDetailInfoBoxStateProvider(newsId).notifier)
                .state = true;
            ref
                .read(shortFormCommentHeightControllerProvider(newsId).notifier)
                .setShortFormFloatingButtonVisibility(false);
            ref
                .read(bottomNavigationBarStateProvider.notifier)
                .setBottomNavigationBarVisibility(false);

            await showDetailInfoBottomSheet(
              context: context,
              newsId: newsId,
            );

            // 모달 창 닫히면
            // 상세 정보 박스가 닫힌 상태로 변경
            // 플로팅 버튼 보임
            // 바텀 네비게이션바 보임
            ref
                .read(shortFormDetailInfoBoxStateProvider(newsId).notifier)
                .state = false;
            ref
                .read(shortFormCommentHeightControllerProvider(newsId).notifier)
                .setShortFormFloatingButtonVisibility(true);
            ref
                .read(bottomNavigationBarStateProvider.notifier)
                .setBottomNavigationBarVisibility(true);

            return;

          case ShortFormMoreInfoPopupType.nonInterested:
            // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
            if (!isLoggedInUser) {
              showLoginModalBottomSheet(context);
              return;
            }

            final isConfirmed = await showConfirmationDialog(
              context: context,
              content: '정말 관심없음 처리하시겠습니까?',
              confirmText: '관심없음',
              cancelText: '취소',
            );

            // 컨펌하지 않은 경우 리턴
            if (isConfirmed != true) {
              return;
            }

            // 관심없음 처리 요청
            final resp = await ref
                .read(loggedInUserShortFormInfoProvider(newsId).notifier)
                .setNotInterested();

            // 처리 실패 시 에러 메시지 출력
            if (resp.success == false) {
              CustomToastMessage.showErrorToastMessage('관심없음 처리에 실패했습니다.');
              return;
            }

            // 성공 시 성공 메시지 출력
            CustomToastMessage.showSuccessToastMessage('관심없음 처리되었습니다.');

            return;

          case ShortFormMoreInfoPopupType.report:
            // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
            if (!isLoggedInUser) {
              showLoginModalBottomSheet(context);
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
                .read(loggedInUserShortFormInfoProvider(newsId).notifier)
                .reportShortForm(reason: reportType);

            // 신고 실패 시 에러 메시지 출력
            if (resp.success == false) {
              // 이미 신고한 숏폼인 경우 에러 다이얼로그 출력
              if (resp.errorCode ==
                      CustomErrorCode.alreadyReportedShortFormCode &&
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
