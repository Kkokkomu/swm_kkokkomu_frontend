import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_send_button.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/show_shortform_comment_input_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentPostCard extends ConsumerStatefulWidget {
  final int newsId;

  const ShortFormCommentPostCard({
    super.key,
    required this.newsId,
  });

  @override
  ConsumerState<ShortFormCommentPostCard> createState() =>
      _ShortFormCommentInputCardState();
}

class _ShortFormCommentInputCardState
    extends ConsumerState<ShortFormCommentPostCard> {
  static const double _dividerHeight = 1.0;
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        ref
            .read(shortFormCommentHeightControllerProvider(widget.newsId)
                .notifier)
            .setCommentBodySizeSmall();
      },
      child: Column(
        children: [
          const Divider(
            height: _dividerHeight,
            thickness: 1.0,
          ),
          Container(
            width: double.infinity,
            height: Constants.bottomNavigationBarHeightWithSafeArea -
                _dividerHeight,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // 로그인하지 않은 사용자는 댓글 입력을 할 수 없음
                      // 로그인 모달 바텀 시트를 띄워줌
                      if (ref.read(userInfoProvider) is! UserModel) {
                        showLoginModalBottomSheet(context, ref);
                        return;
                      }

                      // 로그인한 사용자인 경우 댓글 입력 바텀 시트를 띄워줌
                      showShortFormCommentInputBottomSheet(
                        context: context,
                        newsId: widget.newsId,
                        commentId: null,
                        index: null,
                        controller: _controller,
                        type: ShortFormCommentSendButtonType.post,
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _controller,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SendButton(
                  newsId: widget.newsId,
                  commentId: null,
                  index: null,
                  controller: _controller,
                  isInBottomSheet: false,
                  type: ShortFormCommentSendButtonType.post,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
