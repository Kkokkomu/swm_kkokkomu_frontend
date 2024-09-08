import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_start_pause_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/custom_better_player_controller_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/custom_better_player_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/detail_emoji_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_box.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class SingleShortForm extends ConsumerWidget {
  final int newsId;
  final int newsIndex;
  final String shortFormUrl;
  final String relatedUrl;
  final ShortFormReactionCountInfo reactionCountInfo;
  final ReactionType? userReactionType;

  const SingleShortForm({
    super.key,
    required this.newsId,
    required this.newsIndex,
    required this.shortFormUrl,
    required this.relatedUrl,
    required this.reactionCountInfo,
    required this.userReactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betterPlayerControllerModel = ref.watch(
      customBetterPlayerControllerProvider(
        (newsId: newsId, shortFormUrl: shortFormUrl),
      ),
    );

    switch (betterPlayerControllerModel) {
      case CustomBetterPlayerControllerModelLoading():
        return const Center(
          child: CustomCircularProgressIndicator(),
        );

      case CustomBetterPlayerControllerModelError():
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              betterPlayerControllerModel.message,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () => ref
                  .read(
                    customBetterPlayerControllerProvider(
                      (newsId: newsId, shortFormUrl: shortFormUrl),
                    ).notifier,
                  )
                  .setUpVideo(),
              child: const Text('재시도'),
            ),
          ],
        );

      case CustomBetterPlayerControllerModel():
        final controller = betterPlayerControllerModel.controller;

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
                        shortFormCommentHeightControllerProvider(newsId)
                            .notifier,
                      )
                      .deactivateReply();

                  return;
                }

                // 대댓글창이 활성화 되지 않고 댓글 창이 활성화 된 경우 댓글 입력창을 닫음
                if (ref
                    .read(shortFormCommentHeightControllerProvider(newsId))
                    .isShortFormCommentVisible) {
                  ref
                      .read(shortFormCommentHeightControllerProvider(newsId)
                          .notifier)
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
                                (newsId: newsId, shortFormUrl: shortFormUrl),
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
                                target:
                                    isShortFormFloatingButtonVisible ? 1 : 0,
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
                              16.0,
                              0.0,
                              16.0,
                              constraints.maxHeight * 0.13 + 52.0 + 16.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SafeArea(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FilterButton(),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SearchButton(),
                                          MoreInfoButton(),
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
                                    const SizedBox(height: 16.0),
                                    ShareButton(
                                      // TODO : 공유 기능 구현하기
                                      // 임시로 relatedUrl을 공유 URL로 사용
                                      shareUrl: relatedUrl,
                                    ),
                                    const SizedBox(height: 16.0),
                                    RelatedUrlButton(
                                      shortFormRelatedURL: relatedUrl,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ShortFormStartPauseButton(newsId: newsId),
                      ),
                      Consumer(
                        builder: (_, ref, child) {
                          final isDetailEmojiButtonVisible = ref.watch(
                              detailEmojiButtonVisibilityProvider(newsId));

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
                                .read(
                                    detailEmojiButtonVisibilityProvider(newsId)
                                        .notifier)
                                .setDetailEmojiButtonVisibility(false);
                          },
                          child: ModalBarrier(
                            onDismiss: () => ref
                                .read(
                                    detailEmojiButtonVisibilityProvider(newsId)
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
                                target:
                                    isShortFormFloatingButtonVisible ? 1 : 0,
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
                              0.0,
                              0.0,
                              16.0,
                              constraints.maxHeight * 0.13,
                            ),
                            child: EmojiButton(
                              newsId: newsId,
                              newsIndex: newsIndex,
                              reactionCountInfo: reactionCountInfo,
                              userReactionType: userReactionType,
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
                          shortFormCommentHeightControllerProvider(newsId)
                              .select(
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
                              onComplete: (_) {
                                // 애니메이션이 종료되었을때 대댓글 입력창이 활성화 되지 않은 경우 대댓글 입력창 정보를 삭제함
                                if (ref
                                        .read(
                                          shortFormCommentHeightControllerProvider(
                                            newsId,
                                          ),
                                        )
                                        .isReplyVisible ==
                                    false) {
                                  ref
                                      .read(
                                        shortFormCommentHeightControllerProvider(
                                          newsId,
                                        ).notifier,
                                      )
                                      .deleteReplyState();
                                }
                              },
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
                              duration: AnimationDuration
                                  .replyAppearAnimationDuration,
                            );
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        );
    }
  }
}
