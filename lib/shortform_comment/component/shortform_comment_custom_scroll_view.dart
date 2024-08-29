import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/common/utils/cursor_pagination_utils.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/guest_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentCustomScrollView extends ConsumerStatefulWidget {
  final PaginationWidgetBuilder<ShortFormCommentModel> itemBuilder;
  final int newsId;
  final double maxCommentBodyHeight;

  const ShortFormCommentCustomScrollView({
    super.key,
    required this.itemBuilder,
    required this.newsId,
    required this.maxCommentBodyHeight,
  });

  @override
  ConsumerState<ShortFormCommentCustomScrollView> createState() =>
      _ShortFormCommentCustomScrollViewState();
}

class _ShortFormCommentCustomScrollViewState
    extends ConsumerState<ShortFormCommentCustomScrollView> {
  late final AutoDisposeStateNotifierProviderFamily<
      CursorPaginationProvider<ShortFormCommentModel,
          IBaseCursorPaginationRepository<ShortFormCommentModel>>,
      CursorPaginationBase,
      int> provider;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    if (ref.read(userInfoProvider) is UserModel) {
      provider = loggedInUserShortFormCommentProvider;
    } else {
      provider = guestUserShortFormCommentProvider;
    }

    controller.addListener(listener);
  }

  void listener() {
    CursorPaginationUtils.paginate(
      controller: controller,
      provider: ref.read(provider(widget.newsId).notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortFormCommentVisibility =
        ref.watch(shortFormCommentVisibilityProvider(widget.newsId));

    if (!shortFormCommentVisibility.isShortFormCommentCreated) {
      return const SizedBox();
    }

    final state = ref.watch(provider(widget.newsId));

    return Column(
      children: [
        CommentHeader(
          onVerticalDragUpdate: (details) => ref
              .read(shortFormCommentHeightControllerProvider((widget.newsId))
                  .notifier)
              .onVerticalDragUpdate(details, widget.maxCommentBodyHeight),
          onVerticalDragEnd: (details) => ref
              .read(shortFormCommentHeightControllerProvider((widget.newsId))
                  .notifier)
              .onVerticalDragEnd(details, widget.maxCommentBodyHeight),
          closeComment: ref
              .read(shortFormCommentHeightControllerProvider((widget.newsId))
                  .notifier)
              .setCommentBodySizeSmall,
        ),
        Expanded(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: Builder(builder: (context) {
                  // 완전 처음 로딩일때
                  if (state is CursorPaginationLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                    );
                  }

                  // 에러
                  if (state is CursorPaginationError) {
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(provider(widget.newsId).notifier)
                                .paginate(forceRefetch: true),
                            child: const Text(
                              '다시시도',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // CursorPagination
                  // CursorPaginationFetchingMore
                  // CursorPaginationRefetching
                  final paginationData =
                      state as CursorPagination<ShortFormCommentModel>;

                  return SliverList.separated(
                    itemCount: paginationData.items.length + 1,
                    itemBuilder: (_, index) {
                      if (index == paginationData.items.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Center(
                            child: paginationData
                                    is CursorPaginationFetchingMore
                                ? const CustomCircularProgressIndicator()
                                : paginationData
                                        is CursorPaginationFetchingMoreError
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (paginationData
                                                    as CursorPaginationFetchingMoreError)
                                                .message,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(height: 16.0),
                                          ElevatedButton(
                                            onPressed: () => ref
                                                .read(provider(widget.newsId)
                                                    .notifier)
                                                .paginate(fetchMore: true),
                                            child: const Text(
                                              '다시시도',
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          ElevatedButton(
                                            onPressed: () => ref
                                                .read(provider(widget.newsId)
                                                    .notifier)
                                                .paginate(forceRefetch: true),
                                            child: const Text(
                                              '전체 새로고침',
                                            ),
                                          ),
                                        ],
                                      )
                                    : index == 0
                                        ? const Text('댓글이 없습니다.')
                                        : const Text('더 가져올 데이터가 없습니다.'),
                          ),
                        );
                      }

                      final paginationItem = paginationData.items[index];

                      return widget.itemBuilder(
                        context,
                        index,
                        paginationItem,
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Column(
                        children: [
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShortFormCommentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final void Function(DragUpdateDetails) _onVerticalDragUpdate;
  final void Function(DragEndDetails) _onVerticalDragEnd;
  final void Function() _closeComment;

  ShortFormCommentHeaderDelegate({
    required void Function(DragUpdateDetails) onVerticalDragUpdate,
    required void Function(DragEndDetails) onVerticalDragEnd,
    required void Function() closeComment,
  })  : _onVerticalDragUpdate = onVerticalDragUpdate,
        _onVerticalDragEnd = onVerticalDragEnd,
        _closeComment = closeComment;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CommentHeader(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        closeComment: _closeComment);
  }

  @override
  double get maxExtent => 67.0;

  @override
  double get minExtent => 67.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
    required void Function(DragUpdateDetails) onVerticalDragUpdate,
    required void Function(DragEndDetails) onVerticalDragEnd,
    required void Function() closeComment,
  })  : _onVerticalDragUpdate = onVerticalDragUpdate,
        _onVerticalDragEnd = onVerticalDragEnd,
        _closeComment = closeComment;

  final void Function(DragUpdateDetails) _onVerticalDragUpdate;
  final void Function(DragEndDetails) _onVerticalDragEnd;
  final void Function() _closeComment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
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
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '댓글',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _closeComment,
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
