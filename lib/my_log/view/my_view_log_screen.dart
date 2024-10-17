import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_sliver_grid_view.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_shortform_card.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_view_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/my_view_log_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyViewLogScreen extends ConsumerWidget {
  static String get routeName => 'my-view-log';

  const MyViewLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      title: '내 시청기록',
      onBackButtonPressed: () => context.pop(),
      child: user is! UserModel
          ? const SizedBox()
          : CursorPaginationSliverGridView<MyViewLogModel>(
              provider: myViewLogProvider,
              itemBuilder: (_, index, model) => GestureDetector(
                onTap: () => context.go(
                  CustomRoutePath.myViewLogShortForm,
                  extra: index,
                ),
                child: ExplorationShortFormCard(
                  newsInfo: model.news.info.news,
                ),
              ),
              emptyWidget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.svg.imgEmpty.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '시청한 뉴스가 없어요',
                    style: CustomTextStyle.body1Medi(
                      color: ColorName.gray200,
                    ),
                  ),
                ],
              ),
              errorWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.svg.imgEmpty.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '시청기록을 불러오는 중 에러가 발생했어요\n다시 시도해주세요',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.body1Medi(
                      color: ColorName.gray200,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomSelectButton(
                      onTap: () => ref
                          .read(myViewLogProvider.notifier)
                          .paginate(forceRefetch: true),
                      content: '시청기록 다시 불러오기',
                      backgroundColor: ColorName.gray100,
                      textColor: ColorName.gray300,
                    ),
                  ),
                ],
              ),
              fetchingMoreErrorWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '시청기록을 더 불러오는 중 에러가 발생했어요\n다시 시도해주세요',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.body1Medi(
                      color: ColorName.gray200,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomSelectButton(
                            onTap: () => ref
                                .read(myViewLogProvider.notifier)
                                .paginate(fetchMore: true),
                            content: '더 불러오기',
                            backgroundColor: ColorName.gray100,
                            textColor: ColorName.gray300,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Flexible(
                          child: CustomSelectButton(
                            onTap: () => ref
                                .read(myViewLogProvider.notifier)
                                .paginate(forceRefetch: true),
                            content: '새로고침',
                            backgroundColor: ColorName.gray100,
                            textColor: ColorName.gray300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0),
                ],
              ),
            ),
    );
  }
}
