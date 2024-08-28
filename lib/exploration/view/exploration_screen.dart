import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/app_colors.dart';
import 'package:swm_kkokkomu_frontend/common/provider/root_tab_scaffold_key_provider.dart';

class ExplorationScreen extends ConsumerWidget {
  static String get routeName => 'exploration';

  const ExplorationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.white000,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  final scaffoldKey = ref.read(rootTabScaffoldKeyProvider);
                  if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                    scaffoldKey.currentState?.closeDrawer();
                    return;
                  }
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              backgroundColor: AppColors.white000,
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              expandedHeight: 120.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('인기 뉴스'),
                centerTitle: true,
              ),
              actions: [
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
              pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 열 개수
                  childAspectRatio: 9 / 16, // 자식 위젯의 가로 세로 비율
                  mainAxisSpacing: 32.0,
                  crossAxisSpacing: 24.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: Colors.teal,
                      child: Center(
                        child: Text(
                          'Item $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 20, // 그리드 항목 수
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
