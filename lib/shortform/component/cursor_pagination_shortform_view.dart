import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_refresh_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_shortform_base.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';

class CursorPaginationShortFormView extends ConsumerStatefulWidget {
  final ShortFormScreenType shortFormScreenType;
  final AutoDisposeStateNotifierProvider<
      CursorPaginationProvider<PaginationShortFormModel,
          IBaseCursorPaginationRepository<PaginationShortFormModel>>,
      CursorPaginationBase> provider;
  final int initialPageIndex;

  const CursorPaginationShortFormView({
    super.key,
    required this.shortFormScreenType,
    required this.provider,
    this.initialPageIndex = 0,
  });

  @override
  ConsumerState<CursorPaginationShortFormView> createState() =>
      _CursorPaginationShortFormViewState();
}

class _CursorPaginationShortFormViewState
    extends ConsumerState<CursorPaginationShortFormView> {
  bool isFirstBuild = true;
  int initialPage = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    if (isFirstBuild) {
      initialPage = widget.initialPageIndex;
      isFirstBuild = false;
    } else {
      initialPage = 0;
    }

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return CustomShortFormBase(
        shortFormScreenType: widget.shortFormScreenType,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColorName.white000),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => ref
                  .read(widget.provider.notifier)
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

    final paginationData = state as CursorPagination<PaginationShortFormModel>;

    return CustomRefreshIndicator(
      onRefresh: () =>
          ref.read(widget.provider.notifier).paginate(forceRefetch: true),
      child: PageView.builder(
        controller: PageController(initialPage: initialPage),
        allowImplicitScrolling: true,
        // 바텀 네비게이션바가 보이고 모달 배리어가 보이지 않을 때만 스크롤 가능하도록 설정
        // 댓글 창이 활성화 된 경우 -> 바텀 네비게이션바가 보이지 않음 -> 스크롤 불가능
        // 감정입력창이 활성화 된 경우 -> 모달 배리어가 보임 -> 스크롤 불가능
        physics: (bottomNavigationBarState.isBottomNavigationBarVisible &&
                !bottomNavigationBarState.isModalBarrierVisible)
            ? const CustomScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: paginationData.items.length + 1,
        onPageChanged: (value) {
          if (state is! CursorPaginationFetchingMoreError &&
              value ==
                  paginationData.items.length -
                      1 -
                      (Constants.cursorPaginationFetchCount * 0.2).toInt()) {
            ref.read(widget.provider.notifier).paginate(fetchMore: true);
          }
        },
        itemBuilder: (context, index) {
          if (index == paginationData.items.length) {
            if (paginationData is CursorPaginationFetchingMore) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }

            if (paginationData is CursorPaginationFetchingMoreError) {
              return CustomShortFormBase(
                shortFormScreenType: widget.shortFormScreenType,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (paginationData as CursorPaginationFetchingMoreError)
                          .message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: ColorName.white000),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(widget.provider.notifier)
                          .paginate(fetchMore: true),
                      child: const Text(
                        '다시시도',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(widget.provider.notifier)
                          .paginate(forceRefetch: true),
                      child: const Text(
                        '전체 새로고침',
                      ),
                    ),
                  ],
                ),
              );
            }

            return CustomShortFormBase(
              shortFormScreenType: widget.shortFormScreenType,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '더 가져올 데이터가 없습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorName.white000,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(widget.provider.notifier)
                        .paginate(forceRefetch: true),
                    child: const Text('새로고침'),
                  ),
                ],
              ),
            );
          }

          final paginationItem = paginationData.items[index];

          final newsInfo = paginationItem.info.news;

          if (newsInfo.id == Constants.unknownErrorId ||
              newsInfo.shortformUrl == null) {
            debugPrint('newsId 또는 shortFormUrl이 null 값입니다.');

            return CustomShortFormBase(
              shortFormScreenType: widget.shortFormScreenType,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      '비디오 에러 발생\n다음 비디오로 넘어가주세요.',
                      style: TextStyle(
                        color: ColorName.white000,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleShortForm(
            shortFormScreenType: widget.shortFormScreenType,
            // 로그인된 사용자인 경우 provider를 넘겨줌
            newsId: newsInfo.id,
            shortFormUrl: newsInfo.shortformUrl!,
          );
        },
      ),
    );
  }
}
