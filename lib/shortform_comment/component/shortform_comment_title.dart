import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_sort_type_provider.dart';

class ShortFormCommentTitle extends ConsumerWidget {
  final int newsId;
  final double maxCommentBodyHeight;
  final bool isReply;

  const ShortFormCommentTitle({
    super.key,
    required this.newsId,
    required this.maxCommentBodyHeight,
    required this.isReply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onVerticalDragUpdate: (details) => ref
          .read(shortFormCommentHeightControllerProvider((newsId)).notifier)
          .onVerticalDragUpdate(details, maxCommentBodyHeight),
      onVerticalDragEnd: (details) => ref
          .read(shortFormCommentHeightControllerProvider((newsId)).notifier)
          .onVerticalDragEnd(details, maxCommentBodyHeight),
      child: Container(
        color: ColorName.white000,
        child: Column(
          children: [
            const SizedBox(height: 6.0),
            Container(
              width: 54.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      // back button
                      if (isReply)
                        IconButton(
                          onPressed: ref
                              .read(
                                shortFormCommentHeightControllerProvider(
                                  (newsId),
                                ).notifier,
                              )
                              .deactivateReply,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 24.0,
                          ),
                        ),
                      Text(
                        isReply ? '답글' : '댓글',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isReply)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(shortFormCommentSortTypeProvider(newsId)
                                      .notifier)
                                  .state = ShortFormCommentSortType.popular,
                              child: const Text('인기순'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(shortFormCommentSortTypeProvider(newsId)
                                      .notifier)
                                  .state = ShortFormCommentSortType.latest,
                              child: const Text('최신순'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: ref
                      .read(
                        shortFormCommentHeightControllerProvider((newsId))
                            .notifier,
                      )
                      .setCommentBodySizeSmall,
                  icon: const Icon(
                    Icons.close,
                    size: 28.0,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 1.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
