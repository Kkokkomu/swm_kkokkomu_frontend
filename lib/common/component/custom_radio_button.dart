import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isEnabled;
  final String text;
  final void Function()? onTap;

  const CustomRadioButton({
    super.key,
    required this.isEnabled,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SvgPicture.asset(
                isEnabled
                    ? Assets.icons.svg.icRadioEnabled.path
                    : Assets.icons.svg.icRadioDisabled.path,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 8.0),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}
