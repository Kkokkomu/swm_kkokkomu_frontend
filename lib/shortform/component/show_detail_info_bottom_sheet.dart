import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_detail_info_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_detail_info_box_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_detail_info_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

Future<dynamic> showDetailInfoBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required int newsId,
  required ShortFormReactionCountInfo reactionCountInfo,
  required ReactionType? userReactionType,
}) {
  // 상세 정보 박스가 열려있는 상태로 변경
  // 플로팅 버튼 숨김
  // 바텀 네비게이션바 숨김
  ref.read(shortFormDetailInfoBoxStateProvider(newsId).notifier).state = true;
  ref
      .read(shortFormCommentHeightControllerProvider(newsId).notifier)
      .setShortFormFloatingButtonVisibility(false);
  ref
      .read(bottomNavigationBarStateProvider.notifier)
      .setBottomNavigationBarVisibility(false);

  return showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.15,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [0.5, 1.0],
        builder: (context, scrollController) {
          return Container(
            color: ColorName.white000,
            child: Consumer(
              builder: (_, ref, child) {
                final detailInfo =
                    ref.watch(shortFormDetailInfoProvider(newsId));

                switch (detailInfo) {
                  case ShortFormDetailInfoModelLoading():
                    return const Center(
                      child: CustomCircularProgressIndicator(),
                    );

                  case ShortFormDetailInfoModelError():
                    return const Center(child: Text('상세 정보를 불러오는데 실패했습니다.'));

                  case ShortFormDetailInfoModel():
                    return CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          backgroundColor: ColorName.white000,
                          elevation: 0.0,
                          scrolledUnderElevation: 0.0,
                          title: const Text('설명'),
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                width: 48.0,
                                height: 6.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: ColorName.gray100,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => context.pop(),
                            ),
                          ],
                          bottom: const PreferredSize(
                            preferredSize: Size.fromHeight(0),
                            child: Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detailInfo.news.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (ReactionType reactionType
                                        in ReactionType.values)
                                      Column(
                                        children: [
                                          userReactionType == reactionType
                                              ? SvgPicture.asset(
                                                  reactionType.blueSvgPath,
                                                )
                                              : SvgPicture.asset(
                                                  reactionType.graySvgPath,
                                                ),
                                          Text(reactionType.label),
                                          Text(
                                            reactionCountInfo
                                                .getReactionCountByType(
                                                  reactionType,
                                                )
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Text('조회수 | ${detailInfo.news.viewCnt}'),
                                Text('업로드 날짜 | ${detailInfo.news.createdAt}'),
                                const Divider(
                                  height: 48.0,
                                ),
                                Text(detailInfo.news.summary),
                                const SizedBox(height: 16.0),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    for (String keyword in detailInfo.keywords)
                                      Text('#$keyword'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          );
        },
      ),
    ),
  );
}
