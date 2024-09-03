import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_list_view.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_card.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/guest_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_sort_type_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentSection extends ConsumerWidget {
  final int newsId;
  final double maxCommentBodyHeight;

  const ShortFormCommentSection({
    super.key,
    required this.newsId,
    required this.maxCommentBodyHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (_, ref, child) {
        final animationDurationAndHeight =
            ref.watch(shortFormCommentHeightControllerProvider((newsId)).select(
          (value) => (duration: value.animationDuration, height: value.height),
        ));

        return AnimatedContainer(
          onEnd: () {
            // 댓글창이 닫히고 애니메이션이 종료된 경우
            // FloatingButton을 보이도록 설정
            if (!ref
                .read(shortFormCommentHeightControllerProvider((newsId)))
                .isShortFormCommentVisible) {
              ref
                  .read(shortFormCommentHeightControllerProvider((newsId))
                      .notifier)
                  .setShortFormFloatingButtonVisibility(true);
            }
          },
          curve: Curves.easeInOut,
          height: animationDurationAndHeight.height,
          duration: animationDurationAndHeight.duration,
          width: double.infinity,
          color: ColorName.white000,
          child: child,
        );
      },
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) => ref
                .read(
                    shortFormCommentHeightControllerProvider((newsId)).notifier)
                .onVerticalDragUpdate(details, maxCommentBodyHeight),
            onVerticalDragEnd: (details) => ref
                .read(
                    shortFormCommentHeightControllerProvider((newsId)).notifier)
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
                            const Text(
                              '댓글',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
          ),
          Expanded(
            child: Consumer(
              builder: (_, ref, __) {
                final user = ref.watch(userInfoProvider);
                final isShortFormCommentCreated = ref.watch(
                    shortFormCommentHeightControllerProvider(newsId)
                        .select((value) => value.isShortFormCommentCreated));

                if (!isShortFormCommentCreated) {
                  return const SizedBox();
                }

                late final AutoDisposeStateNotifierProviderFamily<
                    CursorPaginationProvider<IModelWithId,
                        IBaseCursorPaginationRepository<IModelWithId>>,
                    CursorPaginationBase,
                    int> provider;

                if (user is UserModel) {
                  provider = loggedInUserShortFormCommentProvider;
                } else {
                  provider = guestUserShortFormCommentProvider;
                }

                return CursorPaginationListView<ShortFormCommentModel>(
                  id: newsId,
                  provider: provider,
                  separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                  itemBuilder: (_, index, model) => ShortFormCommentCard(
                    shortFormCommentModel: model,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
