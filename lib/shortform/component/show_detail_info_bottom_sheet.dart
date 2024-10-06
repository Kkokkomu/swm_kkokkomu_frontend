import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_info_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

Future<dynamic> showDetailInfoBottomSheet({
  required BuildContext context,
  required int newsId,
}) =>
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12.0),
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
                    surfaceTintColor: ColorName.white000,
                    elevation: 0.0,
                    scrolledUnderElevation: 0.0,
                    titleSpacing: 18.0,
                    toolbarHeight: 62.0,
                    titleTextStyle: CustomTextStyle.head3(),
                    title: Text(
                      '설명',
                      style: CustomTextStyle.head3(),
                    ),
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    flexibleSpace: const FlexibleSpaceBar(
                      background: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.5),
                          child: CustomGrabber(),
                        ),
                      ),
                    ),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: CustomCloseButton(),
                      ),
                    ],
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(0),
                      child: Divider(
                        thickness: 0.5,
                        height: 0.5,
                        color: ColorName.gray200,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Consumer(
                      builder: (_, ref, __) {
                        final user = ref.watch(userInfoProvider);
                        final newsInfo = user is UserModel
                            ? ref.watch(
                                loggedInUserShortFormInfoProvider(newsId))
                            : ref.watch(guestUserShortFormInfoProvider(newsId));

                        switch (newsInfo) {
                          case ShortFormModelLoading():
                            return const Center(
                              child: CustomCircularProgressIndicator(),
                            );

                          case ShortFormModelError():
                            return Center(
                              child: Text(
                                newsInfo.message,
                                style: CustomTextStyle.body1Medi(
                                  color: ColorName.gray200,
                                ),
                              ),
                            );

                          case ShortFormModel():
                            final userReaction =
                                newsInfo.userReaction.getReactionType();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                  ),
                                  child: Text(
                                    newsInfo.info.news.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: CustomTextStyle.head4(),
                                  ),
                                ),
                                const SizedBox(height: 18.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (ReactionType reactionType
                                        in ReactionType.values)
                                      Column(
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              customBorder:
                                                  const CircleBorder(),
                                              onTap: () {
                                                // 로그인 상태가 아닌 경우 정보창 닫고 로그인 모달창 띄우기
                                                if (user is! UserModel) {
                                                  context.pop();
                                                  showLoginModalBottomSheet(
                                                    context,
                                                  );
                                                  return;
                                                }

                                                // 로그인 상태인 경우 반응 정보 업데이트
                                                // 이미 해당 이모지를 누른 상태인 경우 반응 삭제
                                                userReaction == reactionType
                                                    ? ref
                                                        .read(
                                                          loggedInUserShortFormInfoProvider(
                                                            newsId,
                                                          ).notifier,
                                                        )
                                                        .deleteReaction(
                                                          reactionType:
                                                              reactionType,
                                                        )
                                                    : ref
                                                        .read(
                                                          loggedInUserShortFormInfoProvider(
                                                            newsId,
                                                          ).notifier,
                                                        )
                                                        .putPostReaction(
                                                          reactionType:
                                                              reactionType,
                                                          // userReactionType가 null인 경우는 어떠한 감정표현도 하지 않은 상태
                                                          // userReactionType가 null이 아닌 경우는 이미 다른 이모지를 누른 상태
                                                          isReacted:
                                                              userReaction !=
                                                                  null,
                                                        );
                                              },
                                              child: userReaction ==
                                                      reactionType
                                                  ? SvgPicture.asset(
                                                      reactionType.blueSvgPath,
                                                    )
                                                      .animate()
                                                      .scaleXY(
                                                        begin: 0.1,
                                                        end: 1.0,
                                                      )
                                                      .shake(
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 400,
                                                        ),
                                                      )
                                                      .then()
                                                      .scaleXY(
                                                        begin: 1.4,
                                                        end: 1.1,
                                                      )
                                                      .shake(
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 400,
                                                        ),
                                                      )
                                                  : SvgPicture.asset(
                                                      reactionType.graySvgPath,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            reactionType.label,
                                            style: CustomTextStyle.detail3Reg(
                                              color: ColorName.gray500,
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.compact(
                                              locale: 'ko_KR',
                                            ).format(
                                              newsInfo.reactionCnt
                                                  .getReactionCountByType(
                                                reactionType,
                                              ),
                                            ),
                                            style: CustomTextStyle.detail2Bold(
                                              color: ColorName.gray500,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 27.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '조회수 | ${NumberFormat.compactLong(locale: 'ko_KR').format(newsInfo.info.news.viewCnt)}',
                                        style: CustomTextStyle.detail3Reg(
                                          color: ColorName.gray300,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '업로드 날짜 | ${newsInfo.info.news.createdAt.year == Constants.unknownErrorDateTimeYear ? Constants.unknownErrorString : DateFormat('yyyy.MM.dd a hh:mm', 'ko_KR').format(newsInfo.info.news.createdAt)}',
                                        style: CustomTextStyle.detail3Reg(
                                          color: ColorName.gray300,
                                        ),
                                      ),
                                      const Divider(
                                        height: 48.0,
                                        thickness: 1.0,
                                        color: ColorName.gray200,
                                      ),
                                      Text(
                                        newsInfo.info.news.summary,
                                        style: CustomTextStyle.body2Reg(),
                                      ),
                                      const SizedBox(height: 28.0),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: [
                                          for (String keyword
                                              in newsInfo.info.keywords)
                                            Text(
                                              '#$keyword',
                                              style: CustomTextStyle.body3Medi(
                                                color: ColorName.gray200,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
