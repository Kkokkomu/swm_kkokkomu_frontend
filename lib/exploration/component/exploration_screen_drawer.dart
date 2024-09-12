import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';

class ExplorationScreenDrawer extends ConsumerWidget {
  const ExplorationScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: ColorName.white000,
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 80.0,
            child: DrawerHeader(
              child: Text(
                'Newsnack',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          for (NewsCategoryInExploration category
              in NewsCategoryInExploration.values)
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    category.graySvgPath,
                    width: 32.0,
                    height: 32.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                ref.read(explorationCategoryProvider.notifier).state = category;
                context.pop();
              },
            ),
        ],
      ),
    );
  }
}
