import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_sliver_grid_view.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Handle search icon press
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      // Handle more icon press
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.0,
              height: 1.0,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
