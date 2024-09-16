import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

Future<dynamic> showDetailInfoBottomSheet({
  required BuildContext context,
  required AutoDisposeStateNotifierProvider<LoggedInUserShortFormStateNotifier,
          CursorPaginationBase>?
      shortFormProviderWhenLoggedIn,
  required int newsId,
  required int newsIndex,
  required ShortFormNewsInfo newsInfo,
  required List<String> keywords,
  required ShortFormReactionCountInfo prevReactionCountInfo,
  required ReactionType? prevUserReactionType,
}) =>
    showModalBottomSheet(
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
              child: CustomScrollView(
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
                            newsInfo.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Consumer(
                            builder: (_, ref, __) {
                              final user = ref.watch(userInfoProvider);

                              ShortFormReactionCountInfo reactionCountInfo =
                                  prevReactionCountInfo;
                              ReactionType? userReactionType =
                                  prevUserReactionType;

                              // 로그인 상태인 경우 감정표현이 변경될 수 있으므로
                              // 숏폼 정보를 watch 하고 갱신
                              if (user is UserModel &&
                                  shortFormProviderWhenLoggedIn != null) {
                                // 로그인 상태인 경우 숏폼 정보를 가져옴
                                final shortFormModel =
                                    ref.watch(shortFormProviderWhenLoggedIn);

                                if (shortFormModel
                                    is CursorPagination<ShortFormModel>) {
                                  // CursorPagination<ShortFormModel>인 경우(정상적인 경우)에만 userReactionType 및 reactionCountInfo를 가져옴
                                  userReactionType = shortFormModel
                                      .items[newsIndex].userReaction
                                      .getReactionType();

                                  reactionCountInfo = shortFormModel
                                      .items[newsIndex].reactionCnt;
                                }
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (ReactionType reactionType
                                      in ReactionType.values)
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // 로그인 상태가 아닌 경우 정보창 닫고 로그인 모달창 띄우기
                                            if (ref.read(userInfoProvider)
                                                    is! UserModel ||
                                                shortFormProviderWhenLoggedIn ==
                                                    null) {
                                              context.pop();
                                              showLoginModalBottomSheet(
                                                context,
                                              );
                                              return;
                                            }

                                            // 로그인 상태인 경우 반응 정보 업데이트
                                            // 이미 해당 이모지를 누른 상태인 경우 반응 삭제
                                            userReactionType == reactionType
                                                ? ref
                                                    .read(
                                                        shortFormProviderWhenLoggedIn
                                                            .notifier)
                                                    .deleteReaction(
                                                      newsId: newsId,
                                                      newsIndex: newsIndex,
                                                      reactionType:
                                                          reactionType,
                                                    )
                                                : ref
                                                    .read(
                                                        shortFormProviderWhenLoggedIn
                                                            .notifier)
                                                    .putPostReaction(
                                                      newsId: newsId,
                                                      newsIndex: newsIndex,
                                                      reactionType:
                                                          reactionType,
                                                      // userReactionType가 null인 경우는 어떠한 감정표현도 하지 않은 상태
                                                      // userReactionType가 null이 아닌 경우는 이미 다른 이모지를 누른 상태
                                                      isReacted:
                                                          userReactionType !=
                                                              null,
                                                    );
                                          },
                                          child:
                                              userReactionType == reactionType
                                                  ? SvgPicture.asset(
                                                      reactionType.blueSvgPath,
                                                    )
                                                      .animate()
                                                      .scaleXY(
                                                        begin: 0.1,
                                                        end: 1.0,
                                                      )
                                                      .shake()
                                                      .then()
                                                      .scaleXY(
                                                        begin: 1.2,
                                                        end: 1.1,
                                                      )
                                                      .shake()
                                                  : SvgPicture.asset(
                                                      reactionType.graySvgPath,
                                                    ),
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
                              );
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Text('조회수 | ${newsInfo.viewCnt}'),
                          Text('업로드 날짜 | ${newsInfo.createdAt}'),
                          const Divider(
                            height: 48.0,
                          ),
                          Text(newsInfo.summary),
                          const SizedBox(height: 16.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              for (String keyword in keywords)
                                Text('#$keyword'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
