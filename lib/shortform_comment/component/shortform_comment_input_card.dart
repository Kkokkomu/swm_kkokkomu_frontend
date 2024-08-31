import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class ShortFormCommentInputCard extends ConsumerWidget {
  static const double _dividerHeight = 1.0;
  final int newsId;

  const ShortFormCommentInputCard({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShortFormCommentVisible = ref.watch(
      shortFormCommentHeightControllerProvider(newsId).select(
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
            .read(shortFormCommentHeightControllerProvider(newsId).notifier)
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
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return const ShortFormCommentInputInBottomSheet();
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
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
  const ShortFormCommentInputInBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 80.0,
        child: Column(
          children: [
            const Divider(
              height: ShortFormCommentInputCard._dividerHeight,
              thickness: 1.0,
            ),
            Container(
              color: Colors.white,
              height: 79.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
