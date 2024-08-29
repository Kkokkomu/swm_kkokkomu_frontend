import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class ExplorationScreenDrawer extends StatelessWidget {
  const ExplorationScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorName.white000,
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
              context.pop();
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
