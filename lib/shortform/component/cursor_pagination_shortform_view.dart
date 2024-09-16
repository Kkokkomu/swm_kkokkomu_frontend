import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/custom_back_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/filter_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/search_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';

class CursorPaginationShortFormView extends ConsumerWidget {
  final ShortFormScreenType shortFormScreenType;
  final AutoDisposeStateNotifierProvider<
      CursorPaginationProvider<ShortFormModel,
          IBaseCursorPaginationRepository<ShortFormModel>>,
      CursorPaginationBase> provider;
  final int initialPageIndex;

  const CursorPaginationShortFormView({
    super.key,
    required this.shortFormScreenType,
    required this.provider,
    this.initialPageIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return _CustomShortFormBase(
        shortFormScreenType: shortFormScreenType,
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
              onPressed: () =>
                  ref.read(provider.notifier).paginate(forceRefetch: true),
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

    final paginationData = state as CursorPagination<ShortFormModel>;

    return RefreshIndicator(
      onRefresh: () => ref.read(provider.notifier).paginate(forceRefetch: true),
      child: PageView.builder(
        controller: PageController(initialPage: initialPageIndex),
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
            ref.read(provider.notifier).paginate(fetchMore: true);
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
              return _CustomShortFormBase(
                shortFormScreenType: shortFormScreenType,
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
                ),
              );
            }

            return _CustomShortFormBase(
              shortFormScreenType: shortFormScreenType,
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
                        .read(provider.notifier)
                        .paginate(forceRefetch: true),
                    child: const Text('새로고침'),
                  ),
                ],
              ),
            );
          }

          final paginationItem = paginationData.items[index];

          final newsInfo = paginationItem.info.news;
          final reactionCountInfo = paginationItem.reactionCnt;
          final userReactionType =
              paginationItem.userReaction.getReactionType();

          if (newsInfo.id == Constants.unknownErrorId ||
              newsInfo.shortformUrl == null) {
            debugPrint('newsId 또는 shortFormUrl이 null 값입니다.');

            return _CustomShortFormBase(
              shortFormScreenType: shortFormScreenType,
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
            shortFormScreenType: shortFormScreenType,
            // 로그인된 사용자인 경우 provider를 넘겨줌
            shortFormProviderWhenLoggedIn: provider
                    is AutoDisposeStateNotifierProvider<
                        LoggedInUserShortFormStateNotifier,
                        CursorPaginationBase>
                ? provider as AutoDisposeStateNotifierProvider<
                    LoggedInUserShortFormStateNotifier, CursorPaginationBase>
                : null,
            newsId: newsInfo.id,
            newsIndex: index,
            shortFormUrl: newsInfo.shortformUrl!,
            newsInfo: newsInfo,
            keywords: paginationItem.info.keywords,
            reactionCountInfo: reactionCountInfo,
            userReactionType: userReactionType,
          );
        },
      ),
    );
  }
}

class _CustomShortFormBase extends StatelessWidget {
  final ShortFormScreenType shortFormScreenType;
  final Widget child;

  const _CustomShortFormBase({
    required this.shortFormScreenType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 홈 화면에서만 필터 버튼을 보여줌
                shortFormScreenType == ShortFormScreenType.home
                    ? const FilterButton()
                    : const CustomBackButton(),
                const SearchButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
