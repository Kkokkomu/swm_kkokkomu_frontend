import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_refresh_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';

class CursorPaginationListViewByProviderFamily<T extends IModelWithId>
    extends ConsumerWidget {
  final AutoDisposeStateNotifierProviderFamily<CursorPaginationProvider,
      CursorPaginationBase, int> provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final PaginationSeparatorBuilder separatorBuilder;
  final int id;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? fetchingMoreErrorWidget;
  final ScrollController? scrollController;

  const CursorPaginationListViewByProviderFamily({
    super.key,
    required this.provider,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.id,
    this.emptyWidget,
    this.errorWidget,
    this.fetchingMoreErrorWidget,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider(id));

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return CustomRefreshIndicator(
        onRefresh: () =>
            ref.read(provider(id).notifier).paginate(forceRefetch: true),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: errorWidget ??
                  Column(
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
                            .read(provider(id).notifier)
                            .paginate(forceRefetch: true),
                        child: const Text(
                          '다시시도',
                        ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final paginationData = state as CursorPagination<T>;

    if (paginationData.items.isEmpty) {
      return CustomRefreshIndicator(
        onRefresh: () =>
            ref.read(provider(id).notifier).paginate(forceRefetch: true),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: emptyWidget ?? const Text('데이터가 없습니다'),
              ),
            ),
          ],
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: () =>
          ref.read(provider(id).notifier).paginate(forceRefetch: true),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Scrollbar(
          controller: scrollController,
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: paginationData.items.length + 1,
            separatorBuilder: separatorBuilder,
            itemBuilder: (_, index) {
              if (state is! CursorPaginationFetchingMoreError &&
                  index ==
                      paginationData.items.length -
                          1 -
                          (Constants.cursorPaginationFetchCount * 0.1)
                              .toInt()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(provider(id).notifier).paginate(fetchMore: true);
                });
              }

              if (index == paginationData.items.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Center(
                    child: paginationData is CursorPaginationFetchingMore
                        ? const CustomCircularProgressIndicator()
                        : paginationData is CursorPaginationFetchingMoreError
                            ? fetchingMoreErrorWidget ??
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (paginationData
                                              as CursorPaginationFetchingMoreError)
                                          .message,
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () => ref
                                          .read(provider(id).notifier)
                                          .paginate(fetchMore: true),
                                      child: const Text(
                                        '다시시도',
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () => ref
                                          .read(provider(id).notifier)
                                          .paginate(forceRefetch: true),
                                      child: const Text(
                                        '전체 새로고침',
                                      ),
                                    ),
                                  ],
                                )
                            : const SizedBox(),
                  ),
                );
              }

              final paginationItem = paginationData.items[index];

              return itemBuilder(
                context,
                index,
                paginationItem,
              );
            },
          ),
        ),
      ),
    );
  }
}
