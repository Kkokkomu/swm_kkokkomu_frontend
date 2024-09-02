import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentInputCard extends ConsumerStatefulWidget {
  final int newsId;

  const ShortFormCommentInputCard({
    super.key,
    required this.newsId,
  });

  @override
  ConsumerState<ShortFormCommentInputCard> createState() =>
      _ShortFormCommentInputCardState();
}

class _ShortFormCommentInputCardState
    extends ConsumerState<ShortFormCommentInputCard> {
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

                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => ShortFormCommentInputInBottomSheet(
                          newsId: widget.newsId,
                          controller: _controller,
                        ),
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
                _SendButton(
                  newsId: widget.newsId,
                  controller: _controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShortFormCommentInputInBottomSheet extends StatelessWidget {
  final int newsId;
  final TextEditingController controller;

  const ShortFormCommentInputInBottomSheet({
    super.key,
    required this.newsId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: InputBorder.none,
                ),
              ),
            ),
            _SendButton(
              newsId: newsId,
              controller: controller,
              isInBottomSheet: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends ConsumerWidget {
  final int newsId;
  final TextEditingController controller;
  final bool isInBottomSheet;

  const _SendButton({
    required this.newsId,
    required this.controller,
    this.isInBottomSheet = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        // 바텀 시트에서 댓글을 입력한 경우에는 바텀 시트를 닫음
        if (isInBottomSheet) {
          context.pop();
        }

        // 로그인하지 않은 사용자는 댓글 입력을 할 수 없음
        // 로그인 모달 바텀 시트를 띄워주고 리턴
        if (ref.read(userInfoProvider) is! UserModel) {
          showLoginModalBottomSheet(context, ref);
          return;
        }

        if (controller.text.isNotEmpty) {
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
        }
      },
      icon: const Icon(Icons.send),
    );
  }
}
