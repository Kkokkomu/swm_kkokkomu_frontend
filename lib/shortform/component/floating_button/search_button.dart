import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      onTap: () => context.push(CustomRoutePath.search),
      icon: Assets.icons.svg.btnSearchDark.svg(),
    );
  }
}
