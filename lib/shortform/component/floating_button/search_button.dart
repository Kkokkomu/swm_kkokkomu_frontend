import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO : 구현 필요
    return Visibility(
      visible: false,
      child: CustomFloatingButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onTap: () {},
      ),
    );
  }
}
