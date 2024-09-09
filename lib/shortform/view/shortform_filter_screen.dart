import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_radio_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
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

    return DefaultLayout(
      titleWidget: const Text('필터'),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('카테고리'),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (NewsCategory category in NewsCategory.values)
                      CustomCategoryButton(
                        isEnabled: screenSetting.isCategorySelected(category),
                        category: category,
                        onTap: () => ref
                            .read(filterScreenSettingProvider(prevSetting)
                                .notifier)
                            .toggleCategory(category),
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text('정렬'),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    CustomRadioButton(
                      isEnabled: screenSetting.shortFormSortType ==
                          ShortFormSortType.recommend,
                      text: '추천순',
                      onTap: () => ref
                          .read(
                              filterScreenSettingProvider(prevSetting).notifier)
                          .setSortType(ShortFormSortType.recommend),
                    ),
                    const SizedBox(width: 16.0),
                    CustomRadioButton(
                      isEnabled: screenSetting.shortFormSortType ==
                          ShortFormSortType.latest,
                      text: '최신순',
                      onTap: () => ref
                          .read(
                              filterScreenSettingProvider(prevSetting).notifier)
                          .setSortType(ShortFormSortType.latest),
                    ),
                  ],
                ),
              ],
            ),
            SafeArea(
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: GestureDetector(
                      onTap: ref
                          .read(
                              filterScreenSettingProvider(prevSetting).notifier)
                          .reset,
                      child: Container(
                        height: 48.0,
                        color: Colors.grey,
                        child: Center(
                          child: RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Assets.icons.svg.icRe.svg(),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 8.0),
                              ),
                              const TextSpan(text: '초기화'),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        // 변경된 설정을 저장
                        ref
                            .read(loggedInUserShortFormSettingProvider.notifier)
                            .updateSetting(setting: screenSetting);
                        // 필터 스크린을 닫음
                        if (context.mounted) context.pop();
                      },
                      child: Container(
                        height: 48.0,
                        color: Colors.black,
                        child: const Center(
                          child: Text(
                            '필터 적용하기',
                            style: TextStyle(color: ColorName.white000),
                          ),
                        ),
                      ),
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
