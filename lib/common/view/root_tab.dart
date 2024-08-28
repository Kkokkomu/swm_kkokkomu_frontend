import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
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
    final scaffoldKey = ref.watch(rootTabScaffoldKeyProvider);

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
        resizeToAvoidBottomInset: false,
        drawer: navigationShell.currentIndex == 0
            ? const ExplorationScreenDrawer()
            : null,
        bottomNavigationBar: CustomBottomNavigationBar(
          navigationShell: navigationShell,
        ),
        child: navigationShell,
      ),
    );
  }
}

class CustomBottomNavigationBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNavigationBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomNavigationBarVisible =
        ref.watch(bottomNavigationBarStateProvider);

    void refreshCurrentTab(RootTabBottomNavigationBarType tabType) {
      final user = ref.read(userInfoProvider);

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

    return SizedBox(
      height: isBottomNavigationBarVisible
          ? Constants.bottomNavigationBarHeightWithSafeArea
          : 0.0,
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
    );
  }
}
