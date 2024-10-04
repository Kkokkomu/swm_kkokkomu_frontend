import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_report_dialog.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/show_shortform_comment_input_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_like_button_animation_trigger_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/provider/logged_in_user_shortform_reply_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentCard extends ConsumerWidget {
  final ShortFormCommentModel shortFormCommentModel;
  final int index;
  final bool isReply;
  final bool isReplyHeader;
  final int? parentCommentId;

  const ShortFormCommentCard({
    super.key,
    required this.shortFormCommentModel,
    required this.index,
    required this.isReply,
    required this.isReplyHeader,
    required this.parentCommentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    late final bool isMyComment;

    if (user is UserModel && user.id == shortFormCommentModel.user.id) {
      isMyComment = true;
    } else {
      isMyComment = false;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isReply ? 32.0 : 18.0,
        24.0,
        8.0,
        isReplyHeader ? 18.0 : 6.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorName.gray200,
                    width: 0.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    shortFormCommentModel.user.profileImg ?? '',
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Skeletonizer(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          color: ColorName.gray100,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.person,
                        size: 40.0,
                      );
                    },
                    fit: BoxFit.cover,
                    height: 40.0,
                    width: 40.0,
                    cacheWidth: (40.0 * MediaQuery.of(context).devicePixelRatio)
                        .round(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                fit: FlexFit.tight,
                flex: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      shortFormCommentModel.user.nickname,
                      style: CustomTextStyle.detail2Reg(
                        color:
                            isMyComment ? ColorName.blue500 : ColorName.gray400,
                      ),
                    ),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      shortFormCommentModel.comment.editedAt,
                      style:
                          CustomTextStyle.detail3Reg(color: ColorName.gray200),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                padding: EdgeInsets.zero,
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                offset: const Offset(0.0, 41.0),
                menuPadding: EdgeInsets.zero,
                icon: Assets.icons.svg.btnCommentMenu.svg(),
                surfaceTintColor: ColorName.white000,
                color: ColorName.white000,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                onSelected: (value) async {
                  final user = ref.read(userInfoProvider);

                  // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
                  if (user is! UserModel) {
                    showLoginModalBottomSheet(context);
                    return;
                  }

                  switch (value) {
                    case ShortFormCommentPopupType.update:
                      // 댓글 수정 바텀시트 띄우기
                      final controller = TextEditingController(
                        text: shortFormCommentModel.comment.content,
                      );

                      showShortFormCommentInputBottomSheet(
                        context: context,
                        newsId: shortFormCommentModel.comment.newsId,
                        parentCommentId: isReply ? parentCommentId : null,
                        commentId: shortFormCommentModel.id,
                        index: index,
                        controller: controller,
                        type: isReply
                            ? ShortFormCommentSendButtonType.replyUpdate
                            : ShortFormCommentSendButtonType.update,
                      );
                      return;

                    case ShortFormCommentPopupType.delete:
                      // 댓글 삭제 여부 확인 다이얼로그
                      final isDelete = await showConfirmationDialog(
                        context: context,
                        content: '정말 댓글을 삭제하시겠어요?',
                        details: '삭제된 댓글은 복구할 수 없어요',
                        confirmText: '삭제',
                        cancelText: '취소',
                      );

                      // 사용자가 삭제를 선택하지 않은 경우 리턴
                      if (isDelete != true) {
                        return;
                      }

                      // 사용자가 삭제를 선택한 경우 댓글 삭제 요청
                      // 댓글 삭제와 대댓글 삭제 구분
                      final resp = switch (isReply) {
                        true => await ref
                            .read(
                              loggedInUserShortFormReplyProvider(
                                      parentCommentId!)
                                  .notifier,
                            )
                            .deleteReply(
                              newsId: shortFormCommentModel.comment.newsId,
                              replyId: shortFormCommentModel.id,
                              index: index,
                            ),
                        false => await ref
                            .read(
                              loggedInUserShortFormCommentProvider(
                                shortFormCommentModel.comment.newsId,
                              ).notifier,
                            )
                            .deleteComment(
                              commentId: shortFormCommentModel.id,
                              index: index,
                            )
                      };

                      // 삭제 실패 시 에러 메시지 출력
                      if (resp == false) {
                        CustomToastMessage.showErrorToastMessage(
                            '댓글 삭제에 실패했습니다.');
                        return;
                      }

                      // 삭제 성공 시 성공 메시지 출력
                      CustomToastMessage.showSuccessToastMessage(
                          '댓글이 삭제되었습니다.');
                      return;

                    case ShortFormCommentPopupType.block:
                      // 유저 차단 여부 확인 다이얼로그
                      final isDelete = await showConfirmationDialog(
                        context: context,
                        content: '정말 해당 유저를 차단하시겠어요?',
                        details: '차단된 유저의 댓글이 숨김 처리돼요',
                        confirmText: '차단',
                        cancelText: '취소',
                      );

                      // 사용자가 차단을 선택하지 않은 경우 리턴
                      if (isDelete != true) {
                        return;
                      }

                      // 사용자가 차단을 선택한 경우 차단 요청
                      // 댓글창에서 차단했는지 대댓글창에서 차단했는지에 따라 다른 provider 사용
                      final resp = switch (isReply) {
                        true => await ref
                            .read(
                              loggedInUserShortFormReplyProvider(
                                      parentCommentId!)
                                  .notifier,
                            )
                            .hideUserAndComment(
                              newsId: shortFormCommentModel.comment.newsId,
                              userId: shortFormCommentModel.user.id,
                            ),
                        false => await ref
                            .read(
                              loggedInUserShortFormCommentProvider(
                                shortFormCommentModel.comment.newsId,
                              ).notifier,
                            )
                            .hideUserAndComment(
                              userId: shortFormCommentModel.user.id,
                            ),
                      };

                      // 삭제 실패 시 에러 메시지 출력
                      if (resp == false) {
                        CustomToastMessage.showErrorToastMessage(
                            '유저 차단에 실패했습니다');
                        return;
                      }

                      // 삭제 성공 시 성공 메시지 출력
                      CustomToastMessage.showSuccessToastMessage('차단 되었어요');
                      return;

                    case ShortFormCommentPopupType.report:
                      final reportType = await showShortFormCommentReportDialog(
                          context: context);

                      // 신고 사유를 선택하지 않은 경우 리턴
                      if (reportType == null) {
                        return;
                      }

                      // 신고 요청
                      final resp = await ref
                          .read(
                            loggedInUserShortFormCommentProvider(
                              shortFormCommentModel.comment.newsId,
                            ).notifier,
                          )
                          .reportComment(
                            commentId: shortFormCommentModel.id,
                            reason: reportType,
                          );

                      // 신고 실패 시 에러 메시지 출력
                      if (resp.success == false) {
                        // 이미 신고한 댓글인 경우 에러 다이얼로그 출력
                        if (resp.errorCode ==
                                CustomErrorCode.alreadyReportedCommentCode &&
                            context.mounted) {
                          showInfoDialog(
                            context: context,
                            content: resp.errorMessage ?? '이미 신고한 댓글입니다.',
                          );
                          return;
                        }

                        CustomToastMessage.showErrorToastMessage(
                            '댓글 신고에 실패했습니다.');
                        return;
                      }

                      // 신고 성공 시 성공 메시지 출력
                      CustomToastMessage.showSuccessToastMessage(
                          '댓글이 신고되었습니다.');
                      return;

                    default:
                      return;
                  }
                },
                itemBuilder: (context) => isMyComment
                    ? <PopupMenuEntry>[
                        PopupMenuItem(
                          height: 40.0,
                          value: ShortFormCommentPopupType.update,
                          child: Center(
                            child: Row(
                              children: [
                                Assets.icons.svg.icEdit.svg(),
                                const SizedBox(width: 2.0),
                                Text(
                                  '수정하기',
                                  style: CustomTextStyle.detail1Reg(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          height: 40.0,
                          value: ShortFormCommentPopupType.delete,
                          child: Center(
                            child: Row(
                              children: [
                                Assets.icons.svg.icDelete.svg(),
                                const SizedBox(width: 2.0),
                                Text(
                                  '삭제하기',
                                  style: CustomTextStyle.detail1Reg(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    : <PopupMenuEntry>[
                        PopupMenuItem(
                          height: 40.0,
                          value: ShortFormCommentPopupType.block,
                          child: Center(
                            child: Row(
                              children: [
                                Assets.icons.svg.icBlock.svg(),
                                const SizedBox(width: 2.0),
                                Text(
                                  '차단하기',
                                  style: CustomTextStyle.detail1Reg(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          height: 40.0,
                          value: ShortFormCommentPopupType.report,
                          child: Center(
                            child: Row(
                              children: [
                                Assets.icons.svg.icReport.svg(),
                                const SizedBox(width: 2.0),
                                Text(
                                  '신고하기',
                                  style: CustomTextStyle.detail1Reg(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
              ),
            ],
          ),
          const SizedBox(height: 1.0),
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortFormCommentModel.comment.content,
                  style: CustomTextStyle.body3Medi(),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final user = ref.read(userInfoProvider);

                          // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
                          if (user is! UserModel) {
                            showLoginModalBottomSheet(context);
                            return;
                          }

                          // 댓글 좋아요 토글 요청
                          // 댓글창 또는 대댓글창에 따라 다른 provider를 사용 (서로 다른 상태 관리)
                          if (!isReply) {
                            ref
                                .read(
                                  loggedInUserShortFormCommentProvider(
                                    shortFormCommentModel.comment.newsId,
                                  ).notifier,
                                )
                                .toggleCommentLike(
                                  commentId: shortFormCommentModel.id,
                                  index: index,
                                );
                            return;
                          }

                          ref
                              .read(loggedInUserShortFormReplyProvider(
                                      parentCommentId!)
                                  .notifier)
                              .toggleCommentLike(
                                replyId: shortFormCommentModel.id,
                                index: index,
                              );
                        },
                        child: Consumer(
                          builder: (_, ref, child) {
                            final isTriggered = ref.watch(
                              shortFormLikeButtonAnimationTriggerProvider(
                                  shortFormCommentModel.id),
                            );

                            // 좋아요 애니메이션이 트리거된 경우 애니메이션 위젯 반환
                            if (isTriggered) {
                              return Assets.icons.svg.btnThumbupEnabled
                                  .svg()
                                  .animate(
                                    // 좋아요 애니메이션 끝난 후에는 애니메이션 트리거 상태를 false로 변경
                                    onComplete: (_) => ref
                                        .read(
                                          shortFormLikeButtonAnimationTriggerProvider(
                                                  shortFormCommentModel.id)
                                              .notifier,
                                        )
                                        .state = false,
                                  )
                                  .scaleXY(begin: 0.1, end: 1.0)
                                  .rotate(begin: 0.0, end: -0.08)
                                  .then()
                                  .scaleXY(begin: 1.4, end: 1.0)
                                  .rotate(begin: 0.0, end: 0.08);
                            }

                            return child!;
                          },
                          child: shortFormCommentModel.userLike
                              ? Assets.icons.svg.btnThumbupEnabled.svg()
                              : Assets.icons.svg.btnThumbupDisabled.svg(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28.0,
                      child: Text(
                        maxLines: 1,
                        '${shortFormCommentModel.commentLikeCnt}',
                        style: CustomTextStyle.detail3Reg(
                          color: ColorName.gray300,
                        ),
                      ),
                    ),
                    if (!isReply)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              // 대댓글의 부모 댓글인 경우 대댓글 버튼 비활성화 (재귀 방지)
                              onTap: isReplyHeader
                                  ? null
                                  // 대댓글 버튼 클릭 시 대댓글 입력창 활성화
                                  : () => ref
                                      .read(
                                        shortFormCommentHeightControllerProvider(
                                          shortFormCommentModel.comment.newsId,
                                        ).notifier,
                                      )
                                      .activateReply(shortFormCommentModel.id),
                              child: Assets.icons.svg.icReply.svg(),
                            ),
                          ),
                          Text(
                            maxLines: 1,
                            shortFormCommentModel.replyCnt.toString(),
                            style: CustomTextStyle.detail3Reg(
                              color: ColorName.gray300,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
