import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
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
        decoration: const BoxDecoration(
          color: ColorName.white000,
          border: Border(
            bottom: BorderSide(
              color: ColorName.gray200,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.5),
            const Center(
              child: CustomGrabber(),
            ),
            Padding(
              padding: EdgeInsets.only(left: isReply ? 0.0 : 18.0, right: 4.0),
              child: Row(
                children: [
                  // back button
                  if (isReply)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: ref
                            .read(
                              shortFormCommentHeightControllerProvider(
                                (newsId),
                              ).notifier,
                            )
                            .deactivateReply,
                        child: Assets.icons.svg.btnBack.svg(),
                      ),
                    ),
                  Text(
                    isReply ? '답글' : '댓글',
                    style: CustomTextStyle.head3(),
                  ),
                  const Spacer(),
                  CustomCloseButton(
                    onTap: ref
                        .read(
                          shortFormCommentHeightControllerProvider((newsId))
                              .notifier,
                        )
                        .setCommentBodySizeSmall,
                  ),
                ],
              ),
            ),
            if (!isReply)
              Consumer(
                builder: (_, ref, __) {
                  final sortType =
                      ref.watch(shortFormCommentSortTypeProvider(newsId));

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 18.0),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () => ref
                              .read(shortFormCommentSortTypeProvider(newsId)
                                  .notifier)
                              .state = ShortFormCommentSortType.popular,
                          child: Ink(
                            width: 58.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color:
                                  sortType == ShortFormCommentSortType.popular
                                      ? ColorName.gray600
                                      : ColorName.white000,
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  sortType == ShortFormCommentSortType.popular
                                      ? null
                                      : Border.all(
                                          color: ColorName.gray100,
                                          width: 1.0,
                                        ),
                            ),
                            child: Center(
                              child: Text(
                                '인기순',
                                style: CustomTextStyle.detail1Reg(
                                  color: sortType ==
                                          ShortFormCommentSortType.popular
                                      ? ColorName.white000
                                      : ColorName.gray500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () => ref
                              .read(shortFormCommentSortTypeProvider(newsId)
                                  .notifier)
                              .state = ShortFormCommentSortType.latest,
                          child: Ink(
                            width: 58.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: sortType == ShortFormCommentSortType.latest
                                  ? ColorName.gray600
                                  : ColorName.white000,
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  sortType == ShortFormCommentSortType.latest
                                      ? null
                                      : Border.all(
                                          color: ColorName.gray100,
                                          width: 1.0,
                                        ),
                            ),
                            child: Center(
                              child: Text(
                                '최신순',
                                style: CustomTextStyle.detail1Reg(
                                  color: sortType ==
                                          ShortFormCommentSortType.latest
                                      ? ColorName.white000
                                      : ColorName.gray500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            SizedBox(height: isReply ? 4.0 : 12.0),
          ],
        ),
      ),
    );
  }
}
