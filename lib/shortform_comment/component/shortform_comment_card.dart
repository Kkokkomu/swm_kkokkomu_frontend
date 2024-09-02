import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/show_shortform_comment_input_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentCard extends ConsumerWidget {
  final ShortFormCommentModel shortFormCommentModel;

  const ShortFormCommentCard({
    super.key,
    required this.shortFormCommentModel,
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
                    onPressed: () {},
                    icon: const Icon(Icons.forum_outlined),
                  ),
                  Text(
                    shortFormCommentModel.replyCnt.toString(),
                  ),
                  const SizedBox(width: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up_outlined,
                      color: shortFormCommentModel.userLike
                          ? ColorName.blue500
                          : null,
                    ),
                  ),
                  Text(
                    shortFormCommentModel.commentLikeCnt.toString(),
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
                  commentId: shortFormCommentModel.id,
                  controller: controller,
                  type: ShortFormCommentSendButtonType.update,
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
                final resp = await ref
                    .read(
                      loggedInUserShortFormCommentProvider(
                        shortFormCommentModel.comment.newsId,
                      ).notifier,
                    )
                    .deleteComment(commentId: shortFormCommentModel.id);

                // 삭제 실패 시 에러 메시지 출력
                if (resp == false) {
                  CustomToastMessage.showErrorToastMessage('댓글 삭제에 실패했습니다.');
                  return;
                }

                // 삭제 성공 시 성공 메시지 출력
                CustomToastMessage.showSuccessToastMessage('댓글이 삭제되었습니다.');
                return;

              case ShortFormCommentPopupType.block:
                // TODO: 차단 기능 구현
                return;

              case ShortFormCommentPopupType.report:
                // TODO: 신고 기능 구현
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
