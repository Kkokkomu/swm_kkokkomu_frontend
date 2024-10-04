import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_send_button.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/show_shortform_comment_input_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentPostCard extends ConsumerStatefulWidget {
  final int newsId;
  final int? parentCommentId;
  final bool isReply;

  const ShortFormCommentPostCard({
    super.key,
    required this.newsId,
    required this.parentCommentId,
    required this.isReply,
  });

  @override
  ConsumerState<ShortFormCommentPostCard> createState() =>
      _ShortFormCommentInputCardState();
}

class _ShortFormCommentInputCardState
    extends ConsumerState<ShortFormCommentPostCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isShortFormCommentVisible = ref.watch(
      shortFormCommentHeightControllerProvider(widget.newsId).select(
        (value) => value.isShortFormCommentVisible,
      ),
    );

    // 댓글이 보이지 않는 상태에서는 댓글 입력 카드를 표시하지 않음
    if (!isShortFormCommentVisible) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      height: Constants.bottomNavigationBarHeightWithSafeArea,
      decoration: const BoxDecoration(
        color: ColorName.white000,
        border: Border(
          top: BorderSide(
            color: ColorName.gray200,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 7.0, 8.0, 7.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // 로그인하지 않은 사용자는 댓글 입력을 할 수 없음
                  // 로그인 모달 바텀 시트를 띄워줌
                  if (ref.read(userInfoProvider) is! UserModel) {
                    showLoginModalBottomSheet(context);
                    return;
                  }

                  // 로그인한 사용자인 경우 댓글 입력 바텀 시트를 띄워줌
                  showShortFormCommentInputBottomSheet(
                    context: context,
                    newsId: widget.newsId,
                    parentCommentId:
                        widget.isReply ? widget.parentCommentId : null,
                    commentId: null,
                    index: null,
                    controller: _controller,
                    type: widget.isReply
                        ? ShortFormCommentSendButtonType.replyPost
                        : ShortFormCommentSendButtonType.post,
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText: '댓글을 입력하세요',
                    controller: _controller,
                    readOnly: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            SendButton(
              newsId: widget.newsId,
              parentCommentId: widget.isReply ? widget.parentCommentId : null,
              commentId: null,
              index: null,
              controller: _controller,
              isInBottomSheet: false,
              type: widget.isReply
                  ? ShortFormCommentSendButtonType.replyPost
                  : ShortFormCommentSendButtonType.post,
            ),
          ],
        ),
      ),
    );
  }
}
