import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('로고 들어갈자리'),
            SizedBox(height: 16.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
