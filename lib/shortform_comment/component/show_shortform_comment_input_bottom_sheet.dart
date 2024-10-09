import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field_clear_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_send_button.dart';

Future<dynamic> showShortFormCommentInputBottomSheet({
  required BuildContext context,
  required int newsId,
  required int? parentCommentId,
  required int? commentId,
  required int? index,
  required TextEditingController controller,
  required ShortFormCommentSendButtonType type,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(),
    backgroundColor: ColorName.white000,
    builder: (BuildContext _) {
      return PopScope(
        // 댓글 수정인 경우 뒤로가기를 통해 취소시 다이얼로그를 띄워 한번 더 확인
        canPop: type == ShortFormCommentSendButtonType.update ||
                type == ShortFormCommentSendButtonType.replyUpdate
            ? false
            : true,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;

          final resp = await showConfirmationDialog(
            context: context,
            content: '정말 댓글 수정을 취소하시겠어요?',
            details: '작성 중인 댓글은 저장되지 않아요',
            confirmText: '수정 취소',
            cancelText: '계속하기',
          );

          if (resp == true && context.mounted) {
            context.pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            18.0,
            7.0,
            8.0,
            MediaQuery.of(context).viewInsets.bottom + 7.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: controller,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 3,
                  maxLength: Constants.maxCommentLength,
                  hintText: '댓글을 입력하세요',
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: CustomTextFormFieldClearButton(
                      controller: controller,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: SendButton(
                  newsId: newsId,
                  parentCommentId: parentCommentId,
                  commentId: commentId,
                  index: index,
                  controller: controller,
                  isInBottomSheet: true,
                  type: type,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
