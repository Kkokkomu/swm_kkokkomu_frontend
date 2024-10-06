import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_category_provider.dart';

class ExplorationScreenDrawer extends ConsumerWidget {
  const ExplorationScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      surfaceTintColor: ColorName.white000,
      backgroundColor: ColorName.white000,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0.0, 14.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.svg.appIcon.svg(
                      width: 40.0,
                      height: 40.0,
                    ),
                    const SizedBox(width: 8.0),
                    Assets.icons.svg.newsnackTypoLogo.svg(width: 107.0),
                  ],
                ),
              ),
              for (NewsCategoryInExploration category
                  in NewsCategoryInExploration.values)
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 26.0),
                  minVerticalPadding: 0.0,
                  minTileHeight: 60.0,
                  horizontalTitleGap: 8.0,
                  leading: SvgPicture.asset(category.graySvgPath),
                  title: Text(
                    category.label,
                    style: CustomTextStyle.body1Reg(),
                  ),
                  onTap: () {
                    ref.read(explorationCategoryProvider.notifier).state =
                        category;
                    context.pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
