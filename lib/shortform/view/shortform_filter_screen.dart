import 'package:flutter/widgets.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';

class ShortFormFilterScreen extends StatelessWidget {
  static String get routeName => 'filter';

  const ShortFormFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      titleWidget: Text('필터'),
      child: Column(
        children: [],
      ),
    );
  }
}
