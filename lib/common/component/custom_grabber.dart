import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomGrabber extends StatelessWidget {
  const CustomGrabber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.4,
      height: 4.77,
      decoration: BoxDecoration(
        color: ColorName.gray100,
        borderRadius: BorderRadius.circular(2.39),
      ),
    );
  }
}
