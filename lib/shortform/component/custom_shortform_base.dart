import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/custom_back_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/filter_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/floating_button/search_button.dart';

class CustomShortFormBase extends StatelessWidget {
  final ShortFormScreenType shortFormScreenType;
  final Widget child;

  const CustomShortFormBase({
    super.key,
    required this.shortFormScreenType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 홈 화면에서만 필터 버튼을 보여줌
                shortFormScreenType == ShortFormScreenType.home
                    ? const FilterButton()
                    : const CustomBackButton(),
                const SearchButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
