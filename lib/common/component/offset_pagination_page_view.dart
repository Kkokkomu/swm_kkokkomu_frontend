import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/offset_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_offset_pagination_repository.dart';

class OffsetPaginationPageView<T> extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<
      OffsetPaginationProvider<T, BaseOffsetPaginationRepository<T>>,
      OffsetPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const OffsetPaginationPageView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final isBottomNavigationBarVisible =
        ref.watch(bottomNavigationBarStateProvider);

    // 완전 처음 로딩일때
    if (state is OffsetPaginationLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    // 에러
    if (state is OffsetPaginationError) {
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

    // OffsetPagination
    // OffsetPaginationFetchingMore
    // OffsetPaginationRefetching

    final paginationData = state as OffsetPagination<T>;

    return RefreshIndicator(
      onRefresh: () => ref.read(provider.notifier).paginate(forceRefetch: true),
      child: PageView.builder(
        allowImplicitScrolling: true,
        physics: isBottomNavigationBarVisible
            ? const CustomPhysics()
            : const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: paginationData.items.length + 1,
        onPageChanged: (value) {
          if (value == paginationData.items.length - 4) {
            ref.read(provider.notifier).paginate(fetchMore: true);
          }
        },
        itemBuilder: (context, index) {
          if (index == paginationData.items.length) {
            if (paginationData is OffsetPaginationFetchingMore) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }

            if (paginationData is OffsetPaginationFetchingMoreError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (paginationData as OffsetPaginationFetchingMoreError)
                        .message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(provider.notifier).paginate(fetchMore: true),
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
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '더 가져올 데이터가 없습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(provider.notifier).paginate(forceRefetch: true),
                  child: const Text('새로고침'),
                ),
              ],
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
    );
  }
}
