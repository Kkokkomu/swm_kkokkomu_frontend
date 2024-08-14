import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
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

    // 완전 처음 로딩일때
    if (state is OffsetPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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

    return Container(
      color: Colors.black,
      child: PageView.builder(
        allowImplicitScrolling: true,
        physics: const CustomPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: paginationData.items.length + 1,
        onPageChanged: (value) {
          if (value == paginationData.items.length - 2) {
            ref.read(provider.notifier).paginate(fetchMore: true);
          }
        },
        itemBuilder: (context, index) {
          if (index == paginationData.items.length) {
            if (paginationData is OffsetPaginationFetchingMore) {
              return const Center(
                child: CircularProgressIndicator(),
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(provider.notifier).paginate(fetchMore: true),
                    child: const Text(
                      '다시시도',
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text(
                '더 가져올 데이터가 없습니다.',
                style: TextStyle(
                  color: Colors.white,
                ),
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
    );
  }
}
