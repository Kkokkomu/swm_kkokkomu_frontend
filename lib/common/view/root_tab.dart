import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_toggle.dart';
import 'package:swm_kkokkomu_frontend/common/provider/root_tab_scaffold_key_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_screen_drawer.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class RootTab extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const RootTab({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomNavigationBarVisible =
        ref.watch(bottomNavigationBarToggleProvider);
    final user = ref.watch(userInfoProvider);
    final scaffoldKey = ref.read(rootTabScaffoldKeyProvider);

    void refreshCurrentTab(RootTabBottomNavigationBarType tabType) {
      switch (tabType) {
        case RootTabBottomNavigationBarType.exploration:
          break;
        case RootTabBottomNavigationBarType.shortForm:
          if (user is UserModel) {
            ref
                .read(loggedInUserShortFormProvider.notifier)
                .paginate(forceRefetch: true);
          }
          if (user is GuestUserModel) {
            ref
                .read(guestUserShortFormProvider.notifier)
                .paginate(forceRefetch: true);
          }
          break;
        case RootTabBottomNavigationBarType.myPage:
          break;
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
          scaffoldKey.currentState?.closeDrawer();
          return;
        }

        appExitShowDialog(context);
      },
      child: DefaultLayout(
        scaffoldKey: scaffoldKey,
        drawer: navigationShell.currentIndex == 0
            ? const ExplorationScreenDrawer()
            : null,
        bottomNavigationBar: SizedBox(
          height: isBottomNavigationBarVisible ? null : 0.0,
          child: BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              if (index == navigationShell.currentIndex) {
                refreshCurrentTab(RootTabBottomNavigationBarType.values[index]);
                navigationShell.goBranch(index, initialLocation: true);
                return;
              }
              navigationShell.goBranch(index);
            },
            currentIndex: navigationShell.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.electric_bolt),
                label: 'ShortForm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Page',
              ),
            ],
          ),
        ),
        child: navigationShell,
      ),
    );
  }
}
