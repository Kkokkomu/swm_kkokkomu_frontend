import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_radio_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/filter_category_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/filter_screen_setting_provider.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';

class ShortFormFilterScreen extends ConsumerWidget {
  static String get routeName => 'filter';

  const ShortFormFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 기존에 저장된 설정
    final prevSetting = ref.watch(loggedInUserShortFormSettingProvider);
    // 필터 스크린에서 변경된 설정
    final screenSetting = ref.watch(filterScreenSettingProvider(prevSetting));

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      title: '필터',
      onBackButtonPressed: () => context.pop(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 24.0, 18.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '카테고리',
              style: CustomTextStyle.body1Bold(),
            ),
            const SizedBox(height: 12.0),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: [
                for (NewsCategory category in NewsCategory.values)
                  CustomCategoryButton(
                    isEnabled: screenSetting.isCategorySelected(category),
                    category: category,
                    onTap: () => ref
                        .read(filterScreenSettingProvider(prevSetting).notifier)
                        .toggleCategory(category),
                  ),
              ],
            ),
            const SizedBox(height: 28.0),
            Text(
              '정렬',
              style: CustomTextStyle.body1Bold(),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                CustomRadioButton(
                  isEnabled: screenSetting.shortFormSortType ==
                      ShortFormSortType.recommend,
                  text: '추천순',
                  onTap: () => ref
                      .read(filterScreenSettingProvider(prevSetting).notifier)
                      .setSortType(ShortFormSortType.recommend),
                ),
                const SizedBox(width: 7.0),
                CustomRadioButton(
                  isEnabled: screenSetting.shortFormSortType ==
                      ShortFormSortType.latest,
                  text: '최신순',
                  onTap: () => ref
                      .read(filterScreenSettingProvider(prevSetting).notifier)
                      .setSortType(ShortFormSortType.latest),
                ),
              ],
            ),
            const Spacer(),
            SafeArea(
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 94,
                    child: CustomSelectButton(
                      isInkWell: true,
                      onTap: ref
                          .read(
                              filterScreenSettingProvider(prevSetting).notifier)
                          .reset,
                      prefixIcon: Assets.icons.svg.icRe.svg(),
                      content: '초기화',
                      backgroundColor: ColorName.white000,
                      textStyle: CustomTextStyle.body1Medi(),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 233,
                    child: CustomSelectButton(
                      onTap: () async {
                        // 변경된 설정을 저장
                        final resp = await ref
                            .read(loggedInUserShortFormSettingProvider.notifier)
                            .updateSetting(setting: screenSetting);

                        if (!resp) {
                          CustomToastMessage.showErrorToastMessage(
                            '필터 적용에 실패했습니다.',
                          );
                          return;
                        }

                        // 필터 스크린을 닫음
                        if (context.mounted) context.pop();
                      },
                      content: '필터 적용하기',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
