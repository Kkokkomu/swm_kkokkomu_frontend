import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

class CustomCategoryButton extends StatelessWidget {
  static const double _iconSize = 24.0;

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
          vertical: 8.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          color: isEnabled ? Colors.black : Colors.white,
        ),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SvgPicture.asset(
                  category.getBlueSvgPath(),
                  width: _iconSize,
                  height: _iconSize,
                ),
              ),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(width: 8.0),
              ),
              TextSpan(
                text: category.label,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isEnabled ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
