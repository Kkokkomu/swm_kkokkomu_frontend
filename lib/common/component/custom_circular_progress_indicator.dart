import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;

  const CustomCircularProgressIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? ColorName.blue500,
    );
  }
}
