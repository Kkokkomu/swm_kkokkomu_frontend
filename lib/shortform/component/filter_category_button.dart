import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomCategoryButton extends StatelessWidget {
  final NewsCategory category;
  final bool isEnabled;
  final void Function()? onTap;

  const CustomCategoryButton({
    super.key,
    required this.category,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isEnabled ? Colors.transparent : ColorName.gray100,
            width: 1.0,
          ),
          color: isEnabled ? ColorName.gray600 : ColorName.white000,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              category.blueSvgPath,
            ),
            const SizedBox(width: 4.0),
            Text(
              category.label,
              style: CustomTextStyle.detail1Reg(
                color: isEnabled ? ColorName.white000 : ColorName.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
