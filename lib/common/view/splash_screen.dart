import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      statusBarBrightness: Brightness.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ColorName.splashGradationStart,
              ColorName.splashGradationEnd,
            ],
          ),
        ),
        child: Center(
          child: Assets.icons.svg.splashLogo.svg(),
        ),
      ),
    );
  }
}
