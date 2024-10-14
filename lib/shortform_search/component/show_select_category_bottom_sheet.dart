import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/filter_category_button.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/model/search_shortform_category_filter_model.dart';

Future<SearchShortFormCategoryFilterModel?> showSelectCategoryBottomSheet({
  required BuildContext context,
  required SearchShortFormCategoryFilterModel filterModel,
}) {
  // 모든 카테고리 선택 == 모든 카테고리 비선택 으로 취급
  SearchShortFormCategoryFilterModel tempFilterModel =
      filterModel.isAllCategorySelected()
          ? SearchShortFormCategoryFilterModel(
              economy: false,
              entertain: false,
              it: false,
              living: false,
              politics: false,
              social: false,
              sports: false,
              world: false,
            )
          : filterModel.copyWith();

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (_, setState) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Container(
          color: ColorName.white000,
          height: 296.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.5),
              const Center(
                child: CustomGrabber(),
              ),
              const SizedBox(height: 9.73),
              Row(
                children: [
                  const SizedBox(width: 18.0),
                  Text(
                    '카테고리',
                    style: CustomTextStyle.head3(),
                  ),
                  const Spacer(),
                  const CustomCloseButton(),
                  const SizedBox(width: 4.0),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 48.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: [
                    for (NewsCategory category in NewsCategory.values)
                      CustomCategoryButton(
                        isEnabled: tempFilterModel.isCategorySelected(category),
                        category: category,
                        onTap: () {
                          tempFilterModel = switch (category) {
                            NewsCategory.politics => tempFilterModel.copyWith(
                                politics: !tempFilterModel.politics,
                              ),
                            NewsCategory.economy => tempFilterModel.copyWith(
                                economy: !tempFilterModel.economy,
                              ),
                            NewsCategory.social => tempFilterModel.copyWith(
                                social: !tempFilterModel.social,
                              ),
                            NewsCategory.entertain => tempFilterModel.copyWith(
                                entertain: !tempFilterModel.entertain,
                              ),
                            NewsCategory.sports => tempFilterModel.copyWith(
                                sports: !tempFilterModel.sports,
                              ),
                            NewsCategory.living => tempFilterModel.copyWith(
                                living: !tempFilterModel.living,
                              ),
                            NewsCategory.world => tempFilterModel.copyWith(
                                world: !tempFilterModel.world,
                              ),
                            NewsCategory.it => tempFilterModel.copyWith(
                                it: !tempFilterModel.it,
                              ),
                          };

                          setState(() {});
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 94,
                      child: CustomSelectButton(
                        prefixIcon: Assets.icons.svg.icRe.svg(),
                        content: '초기화',
                        isInkWell: true,
                        backgroundColor: ColorName.white000,
                        textStyle: CustomTextStyle.body1Medi(),
                        onTap: () => setState(
                          () => tempFilterModel =
                              SearchShortFormCategoryFilterModel(
                            economy: false,
                            entertain: false,
                            it: false,
                            living: false,
                            politics: false,
                            social: false,
                            sports: false,
                            world: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      flex: 233,
                      child: CustomSelectButton(
                        content: '필터 적용하기',
                        onTap: () {
                          // 모두 비선택일 경우 모든 카테고리 선택으로 취급
                          if (tempFilterModel.isAllCategoryUnSelected()) {
                            tempFilterModel =
                                SearchShortFormCategoryFilterModel(
                              economy: true,
                              entertain: true,
                              it: true,
                              living: true,
                              politics: true,
                              social: true,
                              sports: true,
                              world: true,
                            );
                          }

                          context.pop(tempFilterModel);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
