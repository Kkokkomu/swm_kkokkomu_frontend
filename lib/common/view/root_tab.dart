import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_toggle.dart';
import 'package:swm_kkokkomu_frontend/shorts/view/shortform_screen.dart';
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

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);

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
        appExitShowDialog(context);
      },
      child: DefaultLayout(
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
            ShortsScreen(),
            MyPage(),
          ],
        ),
      ),
    );
  }
}
