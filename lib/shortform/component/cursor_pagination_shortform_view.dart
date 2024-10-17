import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_refresh_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_shortform_base.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_model_with_id_and_url.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';

class CursorPaginationShortFormView extends ConsumerStatefulWidget {
  final ShortFormScreenType shortFormScreenType;
  final AutoDisposeStateNotifierProvider<
      CursorPaginationProvider<
          IShortFormModelWithIdAndNewsIdAndUrl,
          IBaseCursorPaginationRepository<
              IShortFormModelWithIdAndNewsIdAndUrl>>,
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
            Assets.images.svg.imgEmpty.svg(),
            const SizedBox(height: 6.0),
            Text(
              '뉴스를 불러오는 중 에러가 발생했어요\n다시 시도해주세요',
              textAlign: TextAlign.center,
              style: CustomTextStyle.body1Medi(
                color: ColorName.gray200,
              ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: CustomSelectButton(
                onTap: () => ref
                    .read(widget.provider.notifier)
                    .paginate(forceRefetch: true),
                content: '뉴스 다시 불러오기',
                backgroundColor: ColorName.gray100,
                textColor: ColorName.gray300,
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
        state as CursorPagination<IShortFormModelWithIdAndNewsIdAndUrl>;

    if (paginationData.items.isEmpty) {
      return CustomRefreshIndicator(
        onRefresh: () =>
            ref.read(widget.provider.notifier).paginate(forceRefetch: true),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: CustomShortFormBase(
                shortFormScreenType: widget.shortFormScreenType,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.svg.imgEmpty.svg(),
                      const SizedBox(height: 6.0),
                      Text(
                        '일치하는 뉴스가 없어요',
                        style: CustomTextStyle.body1Medi(
                          color: ColorName.gray200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: () =>
          ref.read(widget.provider.notifier).paginate(forceRefetch: true),
      isRefresh: widget.shortFormScreenType == ShortFormScreenType.home,
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
                    Assets.images.svg.imgEmpty.svg(),
                    const SizedBox(height: 6.0),
                    Text(
                      '뉴스를 더 불러오는 중 에러가 발생했어요\n다시 시도해주세요',
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.body1Medi(
                        color: ColorName.gray200,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: CustomSelectButton(
                        onTap: () => ref
                            .read(widget.provider.notifier)
                            .paginate(fetchMore: true),
                        content: '뉴스 더 불러오기',
                        backgroundColor: ColorName.gray100,
                        textColor: ColorName.gray300,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: CustomSelectButton(
                        onTap: () => ref
                            .read(widget.provider.notifier)
                            .paginate(forceRefetch: true),
                        content: '뉴스 처음부터 다시 불러오기',
                        backgroundColor: ColorName.gray100,
                        textColor: ColorName.gray300,
                      ),
                    ),
                  ],
                ),
              );
            }

            return CustomShortFormBase(
              shortFormScreenType: widget.shortFormScreenType,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.svg.imgEmpty.svg(),
                    const SizedBox(height: 6.0),
                    Text(
                      '모든 뉴스를 불러왔어요',
                      style: CustomTextStyle.body1Medi(
                        color: ColorName.gray200,
                      ),
                    ),
                    if (widget.shortFormScreenType == ShortFormScreenType.home)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CustomSelectButton(
                          onTap: () => ref
                              .read(widget.provider.notifier)
                              .paginate(forceRefetch: true),
                          content: '새 뉴스 불러오기',
                          backgroundColor: ColorName.gray100,
                          textColor: ColorName.gray300,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          final paginationItem = paginationData.items[index];

          final newsId = paginationItem.newsId;
          final shortFormUrl = paginationItem.shortFormUrl;

          if (newsId == Constants.unknownErrorId || shortFormUrl == null) {
            debugPrint('newsId 또는 shortFormUrl이 null 값입니다.');

            return CustomShortFormBase(
              shortFormScreenType: widget.shortFormScreenType,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.svg.imgEmpty.svg(),
                    const SizedBox(height: 6.0),
                    Text(
                      '에러가 발생했어요\n다음 영상으로 넘어가주세요',
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.body1Medi(
                        color: ColorName.gray200,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleShortForm(
            shortFormScreenType: widget.shortFormScreenType,
            // 로그인된 사용자인 경우 provider를 넘겨줌
            newsId: newsId,
            shortFormUrl: shortFormUrl,
          );
        },
      ),
    );
  }
}
