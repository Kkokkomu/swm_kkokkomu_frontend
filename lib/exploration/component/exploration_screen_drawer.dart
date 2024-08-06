import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/colors.dart';

class ExplorationScreenDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ExplorationScreenDrawer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BACKGROUND_COLOR,
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 80.0,
            child: DrawerHeader(
              child: Text(
                '꼬꼬무 뉴스',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
        ],
      ),
    );
  }
}
