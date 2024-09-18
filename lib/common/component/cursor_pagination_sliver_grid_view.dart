import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';

class CursorPaginationSliverGridView<T extends IModelWithId>
    extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<CursorPaginationProvider,
      CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final ScrollController? scrollController;

  const CursorPaginationSliverGridView({
    super.key,
    required this.provider,
    required this.itemBuilder,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () =>
                ref.read(provider.notifier).paginate(forceRefetch: true),
            child: const Text(
              '다시시도',
            ),
          ),
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final paginationData = state as CursorPagination<T>;

    if (paginationData.items.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(provider.notifier).paginate(forceRefetch: true),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Scrollbar(
          controller: scrollController,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 24.0,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 열 개수
                    childAspectRatio: 164.0 / 230.0, // 자식 위젯의 가로 세로 비율
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: paginationData.items.length, // 그리드 항목 수
                    (BuildContext _, int index) {
                      // 일정 개수 이하로 남았을 때 페이지네이션하여 추가로 데이터를 가져온다
                      if (state is! CursorPaginationFetchingMoreError &&
                          index ==
                              paginationData.items.length -
                                  1 -
                                  (Constants.cursorPaginationFetchCount * 0.1)
                                      .toInt()) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            ref
                                .read(provider.notifier)
                                .paginate(fetchMore: true);
                          },
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
              paginationData is CursorPaginationFetchingMore
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CustomCircularProgressIndicator(),
                        ),
                      ),
                    )
                  : paginationData is CursorPaginationFetchingMoreError
                      ? SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (paginationData
                                        as CursorPaginationFetchingMoreError)
                                    .message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () => ref
                                    .read(provider.notifier)
                                    .paginate(fetchMore: true),
                                child: const Text(
                                  '다시시도',
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () => ref
                                    .read(provider.notifier)
                                    .paginate(forceRefetch: true),
                                child: const Text(
                                  '전체 새로고침',
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SliverToBoxAdapter(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
