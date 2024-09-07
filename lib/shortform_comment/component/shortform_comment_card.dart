import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
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
  final int? parentCommentId;

  const ShortFormCommentCard({
    super.key,
    required this.shortFormCommentModel,
    required this.index,
    required this.isReply,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReply)
          const SizedBox(
            width: 24.0,
          ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              shortFormCommentModel.user.profileImg ?? '',
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.account_circle_outlined);
              },
              fit: BoxFit.cover,
              height: 36.0,
              width: 36.0,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: shortFormCommentModel.user.nickname,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (isMyComment)
                      WidgetSpan(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: ColorName.blue500,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            '내 댓글',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                shortFormCommentModel.comment.editedAt,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                shortFormCommentModel.comment.content,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final user = ref.read(userInfoProvider);

                      // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
                      if (user is! UserModel) {
                        showLoginModalBottomSheet(context, ref);
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
                    icon: Consumer(
                      builder: (_, ref, child) {
                        final isTriggered = ref.watch(
                          shortFormLikeButtonAnimationTriggerProvider(
                              shortFormCommentModel.id),
                        );

                        // 좋아요 애니메이션이 트리거된 경우 애니메이션 위젯 반환
                        if (isTriggered) {
                          return const Icon(
                            Icons.thumb_up,
                            color: ColorName.blue500,
                          )
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
                              .rotate(begin: 0.0, end: -0.08)
                              .then()
                              .rotate(begin: 0.0, end: 0.08);
                        }

                        return child!;
                      },
                      child: Icon(
                        shortFormCommentModel.userLike
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        color: shortFormCommentModel.userLike
                            ? ColorName.blue500
                            : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    shortFormCommentModel.commentLikeCnt.toString(),
                  ),
                  if (!isReply)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 16.0),
                        IconButton(
                          // 대댓글 버튼 클릭 시 대댓글 입력창 활성화
                          onPressed: () => ref
                              .read(
                                shortFormCommentHeightControllerProvider(
                                  shortFormCommentModel.comment.newsId,
                                ).notifier,
                              )
                              .activateReply(shortFormCommentModel.id),
                          icon: const Icon(Icons.forum_outlined),
                        ),
                        Text(
                          shortFormCommentModel.replyCnt.toString(),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            final user = ref.read(userInfoProvider);

            // 로그인된 사용자가 아닌 경우 로그인 바텀시트를 띄워주고 리턴
            if (user is! UserModel) {
              showLoginModalBottomSheet(context, ref);
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
                  content: '정말 댓글을 삭제하시겠습니까?',
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
                        loggedInUserShortFormReplyProvider(parentCommentId!)
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
                  CustomToastMessage.showErrorToastMessage('댓글 삭제에 실패했습니다.');
                  return;
                }

                // 삭제 성공 시 성공 메시지 출력
                CustomToastMessage.showSuccessToastMessage('댓글이 삭제되었습니다.');
                return;

              case ShortFormCommentPopupType.block:
                // 유저 차단 여부 확인 다이얼로그
                final isDelete = await showConfirmationDialog(
                  context: context,
                  content: '정말 해당 유저를 차단하시겠습니까?',
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
                        loggedInUserShortFormReplyProvider(parentCommentId!)
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
                  CustomToastMessage.showErrorToastMessage('유저 차단에 실패했습니다');
                  return;
                }

                // 삭제 성공 시 성공 메시지 출력
                CustomToastMessage.showSuccessToastMessage('차단 되었어요');
                return;

              case ShortFormCommentPopupType.report:
                final reportType =
                    await showShortFormCommentReportDialog(context: context);

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

                  CustomToastMessage.showErrorToastMessage('댓글 신고에 실패했습니다.');
                  return;
                }

                // 신고 성공 시 성공 메시지 출력
                CustomToastMessage.showSuccessToastMessage('댓글이 신고되었습니다.');
                return;

              default:
                return;
            }
          },
          itemBuilder: (context) => isMyComment
              ? <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: ShortFormCommentPopupType.update,
                    child: Text('수정'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: ShortFormCommentPopupType.delete,
                    child: Text('삭제'),
                  ),
                ]
              : <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: ShortFormCommentPopupType.block,
                    child: Text('차단'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: ShortFormCommentPopupType.report,
                    child: Text('신고'),
                  ),
                ],
        ),
      ],
    );
  }
}
