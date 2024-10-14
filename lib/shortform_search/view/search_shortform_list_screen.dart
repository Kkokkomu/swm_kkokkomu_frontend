import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_sliver_grid_view.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_shortform_card.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/component/show_select_category_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/component/show_select_sort_type_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/guest_user_search_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/logged_in_user_search_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_category_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/search_shortform_sort_type_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class SearchShortFormListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'shortform-search';

  final String searchKeyword;

  const SearchShortFormListScreen({
    super.key,
    required this.searchKeyword,
  });

  @override
  ConsumerState<SearchShortFormListScreen> createState() =>
      _SearchShortFormListScreenState();
}

class _SearchShortFormListScreenState
    extends ConsumerState<SearchShortFormListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoProvider);

    _searchController.text = widget.searchKeyword;

    late final AutoDisposeStateNotifierProvider<
        CursorPaginationProvider<PaginationShortFormModel,
            IBaseCursorPaginationRepository<PaginationShortFormModel>>,
        CursorPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserSearchShortFormProvider(widget.searchKeyword);
    } else {
      provider = guestUserSearchShortFormProvider(widget.searchKeyword);
    }

    return Container(
      color: ColorName.white000,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 18.0, 16.0),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.pop(),
                      child: Assets.icons.svg.btnBack.svg(),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push(
                        CustomRoutePath.search,
                        extra: {
                          GoRouterExtraKeys.searchKeyword: widget.searchKeyword,
                        },
                      ),
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          controller: _searchController,
                          readOnly: true,
                          maxLength: 250,
                          showCounter: false,
                          textInputAction: TextInputAction.search,
                          persistentSuffixIcon: Container(
                            margin: const EdgeInsets.only(right: 4.0),
                            child: Assets.icons.svg.btnSearchSmall.svg(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CursorPaginationSliverGridView<PaginationShortFormModel>(
                provider: provider,
                topPadding: 0.0,
                sliverAppBar: SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  backgroundColor: ColorName.white000,
                  toolbarHeight: 52.0,
                  elevation: 0.0,
                  scrolledUnderElevation: 0.0,
                  actions: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Consumer(
                        builder: (_, ref, __) {
                          final category =
                              ref.watch(searchShortFormCategoryProvider);
                          final sortType =
                              ref.watch(searchShortFormSortTypeProvider);

                          final isDefaultCategory =
                              category.isAllCategorySelected();
                          final isDefaultSortType =
                              sortType == ShortFormSortType.recommend;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () async {
                                  final resp =
                                      await showSelectCategoryBottomSheet(
                                    context: context,
                                    filterModel: ref
                                        .read(searchShortFormCategoryProvider),
                                  );

                                  if (resp != null) {
                                    ref
                                        .read(searchShortFormCategoryProvider
                                            .notifier)
                                        .state = resp;
                                  }
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      width: 1.0,
                                      color: isDefaultCategory
                                          ? ColorName.gray100
                                          : ColorName.blue400,
                                    ),
                                    color: isDefaultCategory
                                        ? null
                                        : ColorName.blue100,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        category.getCategoryFilterLabel(),
                                        style: CustomTextStyle.detail1Reg(
                                          color: isDefaultCategory
                                              ? ColorName.gray500
                                              : ColorName.blue500,
                                        ),
                                      ),
                                      const SizedBox(width: 4.0),
                                      isDefaultCategory
                                          ? Assets.icons.svg.icDownBlack.svg()
                                          : Assets.icons.svg.icDownBlue.svg(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () async {
                                  final resp =
                                      await showSelectSortTypeBottomSheet(
                                    context: context,
                                    sortType: ref
                                        .read(searchShortFormSortTypeProvider),
                                  );

                                  if (resp != null) {
                                    ref
                                        .read(searchShortFormSortTypeProvider
                                            .notifier)
                                        .state = resp;
                                  }
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      width: 1.0,
                                      color: isDefaultSortType
                                          ? ColorName.gray100
                                          : ColorName.blue400,
                                    ),
                                    color: isDefaultSortType
                                        ? null
                                        : ColorName.blue100,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        sortType.label,
                                        style: CustomTextStyle.detail1Reg(
                                          color: isDefaultSortType
                                              ? ColorName.gray500
                                              : ColorName.blue500,
                                        ),
                                      ),
                                      const SizedBox(width: 4.0),
                                      isDefaultSortType
                                          ? Assets.icons.svg.icDownBlack.svg()
                                          : Assets.icons.svg.icDownBlue.svg(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                itemBuilder: (_, index, model) => GestureDetector(
                  onTap: () => context.go(
                    CustomRoutePath.shortFormSearched,
                    extra: {
                      GoRouterExtraKeys.searchKeyword: widget.searchKeyword,
                      GoRouterExtraKeys.initialPageIndex: index,
                    },
                  ),
                  child: ExplorationShortFormCard(
                    newsInfo: model.info.news,
                  ),
                ),
                emptyWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                errorWidget: Column(
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
                            .read(provider.notifier)
                            .paginate(forceRefetch: true),
                        content: '뉴스 다시 불러오기',
                        backgroundColor: ColorName.gray100,
                        textColor: ColorName.gray300,
                      ),
                    ),
                  ],
                ),
                fetchingMoreErrorWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      child: Row(
                        children: [
                          Flexible(
                            child: CustomSelectButton(
                              onTap: () => ref
                                  .read(provider.notifier)
                                  .paginate(fetchMore: true),
                              content: '더 불러오기',
                              backgroundColor: ColorName.gray100,
                              textColor: ColorName.gray300,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Flexible(
                            child: CustomSelectButton(
                              onTap: () => ref
                                  .read(provider.notifier)
                                  .paginate(forceRefetch: true),
                              content: '새로고침',
                              backgroundColor: ColorName.gray100,
                              textColor: ColorName.gray300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
