import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_offset_pagination_repository.dart';

class OffsetPaginationProvider<T, U extends BaseOffsetPaginationRepository<T>>
    extends StateNotifier<OffsetPaginationBase> {
  final U repository;
  final AdditionalParams? additionalParams;

  OffsetPaginationProvider(
    this.repository, {
    this.additionalParams,
  }) : super(OffsetPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 5,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - OffsetPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성
      // State 상태
      // [상태가]
      // 1) OffsetPagination - 정상적으로 데이터가 있는 상태
      // 2) OffsetPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) OffsetPaginationError - 에러가 있는 상태
      // 4) OffsetPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore : true
      //    fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
      if (state is OffsetPagination && !forceRefetch) {
        final pState = state as OffsetPagination;

        if (pState.pageInfo.isLast) {
          return;
        }
      }

      final isLoading = state is OffsetPaginationLoading;
      final isRefetching = state is OffsetPaginationRefetching;
      final isFetchingMore = state is OffsetPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      OffsetPaginationParams offsetPaginationParams = OffsetPaginationParams(
        page: 0,
        size: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as OffsetPagination<T>;

        state = OffsetPaginationFetchingMore(
          pageInfo: pState.pageInfo,
          items: pState.items,
        );

        offsetPaginationParams = offsetPaginationParams.copyWith(
          page: pState.pageInfo.page + 1,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is OffsetPagination && !forceRefetch) {
          final pState = state as OffsetPagination<T>;

          state = OffsetPaginationRefetching<T>(
            pageInfo: pState.pageInfo,
            items: pState.items,
          );
        }
        // 나머지 상황
        else {
          state = OffsetPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        offsetPaginationParams,
        additionalParams: additionalParams,
      );

      if (resp.success != true) {
        throw Exception(resp.error);
      }

      if (state is OffsetPaginationFetchingMore) {
        final pState = state as OffsetPaginationFetchingMore<T>;

        // 기존 데이터에
        // 새로운 데이터 추가
        state = resp.data!.copyWith(
          items: [
            ...pState.items,
            ...resp.data!.items,
          ],
        );
      } else {
        state = resp.data!;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      if (state is OffsetPagination) {
        final pState = state as OffsetPagination<T>;
        state = OffsetPaginationFetchingMoreError(
          items: pState.items,
          pageInfo: pState.pageInfo,
          message: '데이터를 가져오지 못했습니다.',
        );
      } else {
        state = OffsetPaginationError(message: '데이터를 가져오지 못했습니다.');
      }
    }
  }
}
