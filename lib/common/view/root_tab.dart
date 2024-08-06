import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_toggle.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_screen_drawer.dart';
import 'package:swm_kkokkomu_frontend/exploration/view/exploration_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform/view/shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/my_page_screen.dart';

class RootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 1;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: index,
    );

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBottomNavigationBarVisible =
        ref.watch(bottomNavigationBarToggleProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        // Drawer가 열려 있다면 Drawer 닫기
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          _scaffoldKey.currentState!.closeDrawer();
          return;
        }
        appExitShowDialog(context);
      },
      child: DefaultLayout(
        scaffoldKey: _scaffoldKey,
        drawer: index == 0
            ? ExplorationScreenDrawer(scaffoldKey: _scaffoldKey)
            : null,
        bottomNavigationBar: SizedBox(
          height: isBottomNavigationBarVisible ? null : 0.0,
          child: BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              controller.animateTo(index);
            },
            currentIndex: index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.electric_bolt),
                label: 'Shorts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Page',
              ),
            ],
          ),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [
            ExplorationScreen(),
            ShortsScreen(),
            MyPage(),
          ],
        ),
      ),
    );
  }
}
