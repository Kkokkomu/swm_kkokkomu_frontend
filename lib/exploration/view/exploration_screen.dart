import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/colors.dart';

class ExplorationScreen extends StatelessWidget {
  const ExplorationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BACKGROUND_COLOR,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: BACKGROUND_COLOR,
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
