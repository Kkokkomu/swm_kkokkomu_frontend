import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field_clear_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';

/// 항상 context.push를 사용하여 이동하여야 함
class SearchScreen extends StatefulWidget {
  static String get routeName => 'search';

  final String? initialSearchKeyword;

  const SearchScreen({
    super.key,
    this.initialSearchKeyword,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchKeyword != null) {
      _searchController.text = widget.initialSearchKeyword!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultLayoutWithDefaultAppBar(
        backgroundColor: ColorName.white000,
        resizeToAvoidBottomInset: false,
        title: '',
        titleWidget: Container(
          margin: const EdgeInsets.only(right: 14.0),
          child: CustomTextFormField(
            textInputAction: TextInputAction.search,
            controller: _searchController,
            autofocus: true,
            hintText: '검색어를 입력하세요',
            maxLength: 250,
            showCounter: false,
            onFieldSubmitted: (value) {
              if (value != null && value.isNotEmpty) {
                context.go(
                  CustomRoutePath.searchShortFormList,
                  extra: {
                    GoRouterExtraKeys.searchKeyword: value,
                  },
                );
              }
            },
            suffixIcon: CustomTextFormFieldClearButton(
              controller: _searchController,
            ),
            persistentSuffixIcon: Container(
              margin: const EdgeInsets.only(right: 4.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      context.go(
                        CustomRoutePath.searchShortFormList,
                        extra: {
                          GoRouterExtraKeys.searchKeyword:
                              _searchController.text,
                        },
                      );
                    }
                  },
                  child: Assets.icons.svg.btnSearchSmall.svg(),
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 4.0,
        toolbarHeight: 52.0,
        isBottomBorderVisible: false,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorName.white000,
        systemNavigationBarIconBrightness: Brightness.dark,
        onBackButtonPressed: () => context.pop(),
        child: const SizedBox(),
      ),
    );
  }
}
