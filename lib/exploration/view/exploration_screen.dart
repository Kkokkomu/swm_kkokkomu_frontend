import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_sliver_grid_view.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/root_tab_scaffold_key_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_category_button.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_shortform_card.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_screen_scroll_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/guest_user_explore_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/logged_in_user_explore_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ExplorationScreen extends ConsumerWidget {
  static String get routeName => 'exploration';

  const ExplorationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    final category = ref.watch(explorationCategoryProvider);
    final scrollController =
        ref.watch(explorationScreenScrollControllerProvider);

    late final AutoDisposeStateNotifierProvider<
        CursorPaginationProvider<PaginationShortFormModel,
            IBaseCursorPaginationRepository<PaginationShortFormModel>>,
        CursorPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserExploreShortFormProvider;
    } else {
      provider = guestUserExploreShortFormProvider;
    }

    return Container(
      color: ColorName.white000,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 2.0, 4.0, 2.0),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        final scaffoldKey =
                            ref.read(rootTabScaffoldKeyProvider);
                        if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                          scaffoldKey.currentState?.closeDrawer();
                          return;
                        }
                        scaffoldKey.currentState?.openDrawer();
                      },
                      child: ExplorationCategoryButton(
                        category: category,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // TODO : 구현 필요
                  Visibility.maintain(
                    visible: false,
                    child: Assets.icons.svg.btnSearchLight.svg(),
                  ),
                  // TODO : 구현 필요
                  Visibility.maintain(
                    visible: false,
                    child: Assets.icons.svg.btnNoticeDefault.svg(),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.5,
              height: 0.5,
              color: ColorName.gray100,
            ),
            Expanded(
              child: CursorPaginationSliverGridView<PaginationShortFormModel>(
                scrollController: scrollController,
                provider: provider,
                itemBuilder: (_, index, model) => GestureDetector(
                  onTap: () => context.go(
                    CustomRoutePath.explorationShortForm,
                    extra: index,
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
