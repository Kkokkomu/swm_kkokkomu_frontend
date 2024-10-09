import 'package:better_player/better_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_shortform_base.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/comment_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/custom_back_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/emoji_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/filter_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/more_info_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/related_url_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/search_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/share_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_start_pause_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/custom_better_player_controller_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/custom_better_player_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/detail_emoji_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_info_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_info_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_detail_info_box_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_box.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class SingleShortForm extends ConsumerWidget {
  final ShortFormScreenType shortFormScreenType;
  final int newsId;
  final String shortFormUrl;

  const SingleShortForm({
    super.key,
    required this.shortFormScreenType,
    required this.newsId,
    required this.shortFormUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    final betterPlayerControllerModel = ref.watch(
      customBetterPlayerControllerProvider(
        (
          shortFormScreenType: shortFormScreenType,
          newsId: newsId,
          shortFormUrl: shortFormUrl,
        ),
      ),
    );

    final isLoggedInUser = user is UserModel;
    final shortFormModel = isLoggedInUser
        ? ref.watch(loggedInUserShortFormInfoProvider(newsId))
        : ref.watch(guestUserShortFormInfoProvider(newsId));

    // 비디오가 로딩 중이거나 숏폼 정보가 로딩 중인 경우 로딩 스피너를 보여줌
    if (betterPlayerControllerModel
            is CustomBetterPlayerControllerModelLoading ||
        shortFormModel is ShortFormModelLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    if (betterPlayerControllerModel is CustomBetterPlayerControllerModelError ||
        shortFormModel is ShortFormModelError) {
      return CustomShortFormBase(
        shortFormScreenType: shortFormScreenType,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                betterPlayerControllerModel
                        is CustomBetterPlayerControllerModelError
                    ? betterPlayerControllerModel.message
                    : (shortFormModel as ShortFormModelError).message,
                style: const TextStyle(
                  color: ColorName.white000,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () => betterPlayerControllerModel
                        is CustomBetterPlayerControllerModelError
                    // 비디오 로딩 중 에러가 발생한 경우 비디오를 다시 로딩
                    ? ref
                        .read(
                          customBetterPlayerControllerProvider(
                            (
                              shortFormScreenType: shortFormScreenType,
                              newsId: newsId,
                              shortFormUrl: shortFormUrl,
                            ),
                          ).notifier,
                        )
                        .setUpVideo()
                    // 숏폼 정보 로딩 중 에러가 발생한 경우 숏폼 정보를 다시 로딩
                    : isLoggedInUser
                        // 로그인한 사용자인 경우
                        ? ref
                            .read(loggedInUserShortFormInfoProvider(newsId)
                                .notifier)
                            .getShortFormInfo()
                        // 비로그인 사용자인 경우
                        : ref
                            .read(
                                guestUserShortFormInfoProvider(newsId).notifier)
                            .getShortFormInfo(),
                child: const Text('재시도'),
              ),
            ],
          ),
        ),
      );
    }

    // 비디오 정보와 숏폼 정보를 모두 정상적으로 가져온 경우
    final controller =
        (betterPlayerControllerModel as CustomBetterPlayerControllerModel)
            .controller;
    final shortFormInfo = (shortFormModel as ShortFormModel);

    return Consumer(
      builder: (_, ref, child) {
        final isShortFormCommentVisible = ref.watch(
          shortFormCommentHeightControllerProvider(newsId)
              .select((value) => value.isShortFormCommentVisible),
        );

        return PopScope(
          canPop: isShortFormCommentVisible ? false : true,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;

            // 대댓글창이 활성화 된 경우 대댓글 입력창을 닫음
            if (ref
                .read(shortFormCommentHeightControllerProvider(newsId))
                .isReplyVisible) {
              ref
                  .read(
                    shortFormCommentHeightControllerProvider(newsId).notifier,
                  )
                  .deactivateReply();

              return;
            }

            // 대댓글창이 활성화 되지 않고 댓글 창이 활성화 된 경우 댓글 입력창을 닫음
            if (ref
                .read(shortFormCommentHeightControllerProvider(newsId))
                .isShortFormCommentVisible) {
              ref
                  .read(
                      shortFormCommentHeightControllerProvider(newsId).notifier)
                  .setCommentBodySizeSmall();

              return;
            }
          },
          child: SafeArea(
            top: isShortFormCommentVisible,
            child: child!,
          ),
        );
      },
      child: LayoutBuilder(
        builder: (BuildContext _, BoxConstraints constraints) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      // 숏폼 화면을 누를때
                      onTap: () {
                        // 댓글창이 보이는 상태에서 숏폼 화면을 누르면 댓글창 닫음
                        if (ref
                            .read(
                              shortFormCommentHeightControllerProvider(
                                newsId,
                              ),
                            )
                            .isShortFormCommentVisible) {
                          ref
                              .read(shortFormCommentHeightControllerProvider(
                                      newsId)
                                  .notifier)
                              .setCommentBodySizeSmall();

                          return;
                        }

                        ref
                            .read(customBetterPlayerControllerProvider(
                              (
                                shortFormScreenType: shortFormScreenType,
                                newsId: newsId,
                                shortFormUrl: shortFormUrl,
                              ),
                            ).notifier)
                            .togglePausePlay();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: IgnorePointer(
                        child: BetterPlayer(
                          controller: controller,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (_, ref, child) {
                        final isShortFormFloatingButtonVisible = ref.watch(
                          shortFormCommentHeightControllerProvider(
                            newsId,
                          ).select(
                            (value) => value.isShortFormFloatingButtonVisible,
                          ),
                        );

                        return child!
                            .animate(
                              target: isShortFormFloatingButtonVisible ? 1 : 0,
                            )
                            .scaleXY(
                              begin: 0.0,
                              end: 1.0,
                              duration: Duration.zero,
                            );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            4.0,
                            4.0,
                            0.0,
                            constraints.maxHeight * 0.135,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SafeArea(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 홈 화면에서만 필터 버튼을 보여줌
                                    shortFormScreenType ==
                                            ShortFormScreenType.home
                                        ? const FilterButton()
                                        : const CustomBackButton(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SearchButton(),
                                        const SizedBox(width: 4.0),
                                        MoreInfoButton(
                                          isLoggedInUser: isLoggedInUser,
                                          newsId: newsId,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CommentButton(
                                    ref: ref,
                                    newsId: newsId,
                                    maxCommentHeight: constraints.maxHeight,
                                  ),
                                  ShareButton(
                                    newsId: newsId,
                                    // TODO : 공유 기능 구현하기
                                    // 임시로 relatedUrl을 공유 URL로 사용
                                    shareUrl:
                                        shortFormInfo.info.news.relatedUrl,
                                  ),
                                  RelatedUrlButton(
                                    shortFormRelatedURL:
                                        shortFormInfo.info.news.relatedUrl,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ShortFormStartPauseButton(
                        shortFormScreenType: shortFormScreenType,
                        newsId: newsId,
                      ),
                    ),
                    Consumer(
                      builder: (_, ref, child) {
                        final user = ref.watch(userInfoProvider);
                        final isShortFormFloatingButtonVisible = ref.watch(
                          shortFormCommentHeightControllerProvider(
                            newsId,
                          ).select(
                            (value) => value.isShortFormFloatingButtonVisible,
                          ),
                        );

                        return Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              18.0,
                              0.0,
                              20.0,
                              12.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user is! UserModel)
                                  Text.rich(
                                    TextSpan(
                                      text: '맞춤형 서비스를 위해서는\n',
                                      style: CustomTextStyle.detail2Reg(
                                        color: ColorName.white000,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '로그인',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                showLoginModalBottomSheet(
                                                    context),
                                          style: CustomTextStyle.detail2Bold(
                                            color: ColorName.blue500,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: ColorName.blue500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '이 필요합니다',
                                          style: CustomTextStyle.detail2Reg(
                                            color: ColorName.white000,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  shortFormInfo.info.keywords.isEmpty
                                      ? ''
                                      : '#${shortFormInfo.info.keywords.join(' #')}',
                                  style: CustomTextStyle.body3Medi(
                                    color: ColorName.white000,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate(
                              target: isShortFormFloatingButtonVisible ? 1 : 0,
                            )
                            .scaleXY(
                              begin: 0.0,
                              end: 1.0,
                              duration: Duration.zero,
                            );
                      },
                    ),
                    Consumer(
                      builder: (_, ref, child) {
                        final isDetailEmojiButtonVisible = ref
                            .watch(detailEmojiButtonVisibilityProvider(newsId));

                        if (!isDetailEmojiButtonVisible) {
                          return const SizedBox();
                        }

                        return child!;
                      },
                      child: PopScope(
                        canPop: false,
                        onPopInvokedWithResult: (didPop, _) {
                          // canPop이 false 인데 pop이 호출된 경우
                          // PopScope 가 의도된대로 작동하지 않았으므로 무시
                          if (didPop) return;

                          ref
                              .read(detailEmojiButtonVisibilityProvider(newsId)
                                  .notifier)
                              .setDetailEmojiButtonVisibility(false);
                        },
                        child: ModalBarrier(
                          onDismiss: () => ref
                              .read(detailEmojiButtonVisibilityProvider(newsId)
                                  .notifier)
                              .setDetailEmojiButtonVisibility(false),
                          dismissible: true,
                          color: Constants.modalBarrierColor,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (_, ref, child) {
                        final isShortFormFloatingButtonVisible = ref.watch(
                          shortFormCommentHeightControllerProvider(
                            newsId,
                          ).select(
                            (value) => value.isShortFormFloatingButtonVisible,
                          ),
                        );

                        return child!
                            .animate(
                              target: isShortFormFloatingButtonVisible ? 1 : 0,
                            )
                            .scaleXY(
                              begin: 0.0,
                              end: 1.0,
                              duration: Duration.zero,
                            );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: constraints.maxHeight * 0.135 + 64.0 * 3,
                          ),
                          child: EmojiButton(
                            isLoggedInUser: isLoggedInUser,
                            newsId: newsId,
                            shortFormInfo: shortFormInfo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ShortFormCommentBox(
                    newsId: newsId,
                    maxCommentBodyHeight: constraints.maxHeight -
                        Constants.bottomNavigationBarHeightWithSafeArea,
                    isReply: false,
                    parentCommentId: null,
                  ),
                  Consumer(
                    builder: (_, ref, __) {
                      final replyState = ref.watch(
                        shortFormCommentHeightControllerProvider(newsId).select(
                          (value) => (
                            replyParentCommentId: value.parentCommentId,
                            isReplyVisible: value.isReplyVisible,
                          ),
                        ),
                      );

                      // replyParentCommentId가 null인 경우 대댓글 입력창이 활성화 되지 않은 것으로 간주
                      // 대댓글 입력창이 활성화 되지 않은 경우 빈 컨테이너를 반환
                      if (replyState.replyParentCommentId == null) {
                        return const SizedBox();
                      }

                      // 대댓글 입력창이 활성화 된 경우 대댓글 입력창을 반환
                      return ShortFormCommentBox(
                        newsId: newsId,
                        maxCommentBodyHeight: constraints.maxHeight -
                            Constants.bottomNavigationBarHeightWithSafeArea,
                        isReply: true,
                        parentCommentId: replyState.replyParentCommentId,
                      )
                          .animate(
                            target: replyState.isReplyVisible ? 1 : 0,
                          )
                          .scaleXY(
                            begin: 0.0,
                            end: 1.0,
                            duration: Duration.zero,
                          )
                          .then()
                          .slideX(
                            curve: Curves.easeInOut,
                            begin: 1.0,
                            end: 0.0,
                            duration:
                                AnimationDuration.replyAppearAnimationDuration,
                          );
                    },
                  ),
                ],
              ),
              Consumer(
                builder: (_, ref, __) {
                  final isDetailEnabled =
                      ref.watch(shortFormDetailInfoBoxStateProvider(newsId));

                  if (!isDetailEnabled) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: Constants.bottomNavigationBarHeightWithSafeArea,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
