import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

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
        SvgPicture.asset(
          category.blueChipSvgPath,
          width: 48.0,
          height: 48.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          category.label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }
}
