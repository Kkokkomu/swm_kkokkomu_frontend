import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

class ExplorationCategoryButton extends StatelessWidget {
  final NewsCategoryInExploration category;

  const ExplorationCategoryButton({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(category.blueChipSvgPath),
        const SizedBox(width: 8.0),
        Text(
          category.label,
          style: CustomTextStyle.head4(),
        ),
        Assets.icons.svg.btnMenuopen.svg(),
      ],
    );
  }
}
