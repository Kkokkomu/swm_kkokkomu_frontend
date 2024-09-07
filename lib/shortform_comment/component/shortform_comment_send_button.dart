import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/provider/logged_in_user_shortform_reply_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class SendButton extends ConsumerWidget {
  final int newsId;
  final int? parentCommentId;
  final int? commentId;
  final int? index;
  final TextEditingController controller;
  final bool isInBottomSheet;
  final ShortFormCommentSendButtonType type;

  const SendButton({
    super.key,
    required this.newsId,
    required this.parentCommentId,
    required this.commentId,
    required this.index,
    required this.controller,
    required this.type,
    required this.isInBottomSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        // 로그인하지 않은 사용자는 댓글 관련 작업을 할 수 없음
        // 로그인 모달 바텀 시트를 띄워주고 리턴
        if (ref.read(userInfoProvider) is! UserModel) {
          showLoginModalBottomSheet(context, ref);
          return;
        }

        // 댓글이 비어있는 경우 아무것도 하지 않고 리턴
        if (controller.text.isEmpty) {
          return;
        }

        switch (type) {
          // 새 댓글을 작성하는 경우
          case ShortFormCommentSendButtonType.post:
            // 댓글 작성 요청
            final resp = await ref
                .read(loggedInUserShortFormCommentProvider(newsId).notifier)
                .postComment(controller.text);

            // 댓글 작성에 실패한 경우
            // 에러 메시지를 표시하고 리턴
            if (resp == false) {
              CustomToastMessage.showErrorToastMessage('댓글 작성에 실패했습니다');
              return;
            }

            // 댓글 작성에 성공한 경우 완료 메시지를 표시하고 InputField를 초기화
            CustomToastMessage.showSuccessToastMessage('댓글이 작성되었습니다');
            controller.clear();
            break;

          // 댓글을 수정하는 경우
          case ShortFormCommentSendButtonType.update:
            // 댓글 수정을 요청하는데 댓글 ID나 index가 없는 경우 에러 메시지를 표시하고 리턴
            // 또는 에러 값인 경우 에러 메시지를 표시하고 리턴
            if (commentId == null ||
                commentId == Constants.unknownErrorId ||
                index == null) {
              CustomToastMessage.showErrorToastMessage('댓글 수정에 실패했습니다');
              return;
            }

            // 댓글 수정 요청
            final resp = await ref
                .read(loggedInUserShortFormCommentProvider(newsId).notifier)
                .updateComment(
                  commentId: commentId!,
                  content: controller.text,
                  index: index!,
                );

            // 댓글 수정에 실패한 경우 에러 메시지를 표시하고 리턴
            if (resp == false) {
              CustomToastMessage.showErrorToastMessage('댓글 수정에 실패했습니다');
              return;
            }

            // 댓글 수정에 성공한 경우 완료 메시지를 표시
            CustomToastMessage.showSuccessToastMessage('댓글이 수정되었습니다');
            break;

          // 새 대댓글을 작성하는 경우
          case ShortFormCommentSendButtonType.replyPost:
            // 부모 댓글 ID가 없가나 에러 값인 경우 에러 메시지를 표시하고 리턴
            if (parentCommentId == null ||
                parentCommentId == Constants.unknownErrorId) {
              CustomToastMessage.showErrorToastMessage('대댓글 작성에 실패했습니다');
              return;
            }

            // 대댓글 작성 요청
            final resp = await ref
                .read(loggedInUserShortFormReplyProvider(parentCommentId!)
                    .notifier)
                .postReply(
                  newsId: newsId,
                  content: controller.text,
                );

            // 대댓글 작성에 실패한 경우
            // 에러 메시지를 표시하고 리턴
            if (resp == false) {
              CustomToastMessage.showErrorToastMessage('댓글 작성에 실패했습니다');
              return;
            }

            // 대댓글 작성에 성공한 경우 완료 메시지를 표시하고 InputField를 초기화
            CustomToastMessage.showSuccessToastMessage('댓글이 작성되었습니다');
            controller.clear();
            break;

          case ShortFormCommentSendButtonType.replyUpdate:
            // 대댓글 수정을 요청하는데 대댓글 ID나 index가 없는 경우 에러 메시지를 표시하고 리턴
            // 또는 에러 값인 경우 에러 메시지를 표시하고 리턴
            if (commentId == null ||
                commentId == Constants.unknownErrorId ||
                index == null) {
              CustomToastMessage.showErrorToastMessage('댓글 수정에 실패했습니다');
              return;
            }

            // 대댓글 수정 요청
            final resp = await ref
                .read(loggedInUserShortFormReplyProvider(parentCommentId!)
                    .notifier)
                .updateReply(
                  replyId: commentId!,
                  content: controller.text,
                  index: index!,
                );

            // 대댓글 수정에 실패한 경우 에러 메시지를 표시하고 리턴
            if (resp == false) {
              CustomToastMessage.showErrorToastMessage('댓글 수정에 실패했습니다');
              return;
            }

            // 대댓글 수정에 성공한 경우 완료 메시지를 표시
            CustomToastMessage.showSuccessToastMessage('댓글이 수정되었습니다');
            break;

          default:
            return;
        }
        // 바텀 시트에서 댓글을 입력한 경우에는 바텀 시트를 닫음
        if (isInBottomSheet && context.mounted) {
          context.pop();
        }
      },
      icon: const Icon(Icons.send),
    );
  }
}
