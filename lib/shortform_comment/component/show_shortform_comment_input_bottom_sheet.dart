import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
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
            content: '정말 댓글 수정을 취소하시겠습니까?',
            confirmText: '수정 취소',
            cancelText: '계속하기',
          );

          if (resp == true && context.mounted) {
            context.pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: Constants.bottomNavigationBarHeightWithSafeArea,
            ),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.clear();
                        },
                        child: Assets.icons.svg.btnDelete.svg(),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 40.0,
                        minHeight: 40.0,
                        maxWidth: 40.0,
                        maxHeight: 40.0,
                      ),
                    ),
                  ),
                ),
                SendButton(
                  newsId: newsId,
                  parentCommentId: parentCommentId,
                  commentId: commentId,
                  index: index,
                  controller: controller,
                  isInBottomSheet: true,
                  type: type,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
