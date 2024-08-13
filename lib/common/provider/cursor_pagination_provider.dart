import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';

class CursorPaginationProvider<T extends IModelWithId,
        U extends IBaseCursorPaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final AdditionalParams? additionalParams;
  final String apiPath;

  CursorPaginationProvider(
    this.repository, {
    this.additionalParams,
    this.apiPath = '',
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성
      // State의 상태
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      // 바로 반환하는 상황
      // 1) isLast = true (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore: true
      //    fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (pState.pageInfo.isLast) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // CursorPaginationParams 생성
      CursorPaginationParams cursorPaginationParams = CursorPaginationParams(
        size: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          items: pState.items,
          pageInfo: pState.pageInfo,
        );

        cursorPaginationParams = cursorPaginationParams.copyWith(
          cursorId: pState.items.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            items: pState.items,
            pageInfo: pState.pageInfo,
          );
        }
        // 나미저 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        cursorPaginationParams,
        additionalParams: additionalParams,
        apiPath: apiPath,
      );

      final paginationData = resp.data;

      if (resp.success != true || paginationData == null) {
        throw Exception('페이지네이션 실패');
      }

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에
        // 새로운 데이터 추가
        state = paginationData.copyWith(
          items: [
            ...pState.items,
            ...paginationData.items,
          ],
        );
      } else {
        state = paginationData;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      if (state is CursorPagination) {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 에러를 보여줌
        final pState = state as CursorPagination<T>;
        state = CursorPaginationFetchingMoreError(
          items: pState.items,
          pageInfo: pState.pageInfo,
          message: '데이터를 가져오지 못했습니다.',
        );
      } else {
        state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
      }
    }
  }
}