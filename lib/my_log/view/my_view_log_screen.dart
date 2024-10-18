import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_sliver_grid_view.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_shortform_card.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_view_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/my_view_log_provider.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/selected_my_view_log_provider.dart';

class MyViewLogScreen extends ConsumerWidget {
  static String get routeName => 'my-view-log';

  const MyViewLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myViewLog = ref.watch(myViewLogProvider);
    final selectedMyViewLog = ref.watch(selectedMyViewLogProvider);

    final isSelectMode = selectedMyViewLog.isSelectMode;
    final selectedLogIds = selectedMyViewLog.selectedLogIds;

    return PopScope(
      canPop: !isSelectMode,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        ref.read(selectedMyViewLogProvider.notifier).toggleSelectMode();
      },
      child: DefaultLayoutWithDefaultAppBar(
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorName.white000,
        systemNavigationBarIconBrightness: Brightness.dark,
        title: '내 시청기록',
        titleActions: myViewLog is CursorPagination<MyViewLogModel> &&
                myViewLog.items.isNotEmpty
            ? [
                TextButton(
                  onPressed: () => ref
                      .read(selectedMyViewLogProvider.notifier)
                      .toggleSelectMode(),
                  child: Text(
                    isSelectMode ? '취소' : '선택',
                    style: CustomTextStyle.body2Bold(color: ColorName.blue500),
                  ),
                ),
                const SizedBox(width: 4.0),
              ]
            : null,
        onBackButtonPressed: () => context.pop(),
        child: Column(
          children: [
            Expanded(
              child: CursorPaginationSliverGridView<MyViewLogModel>(
                provider: myViewLogProvider,
                isRefreshable: !isSelectMode,
                sliverAppBar: isSelectMode
                    ? SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: true,
                        centerTitle: true,
                        backgroundColor: ColorName.white000,
                        elevation: 0.0,
                        scrolledUnderElevation: 0.0,
                        title: Text(
                          selectedLogIds.isNotEmpty
                              ? '선택한 기록 ${selectedLogIds.length}개'
                              : '삭제할 기록을 선택해주세요',
                          style: CustomTextStyle.detail1Reg(
                            color: ColorName.gray300,
                          ),
                        ),
                      )
                    : null,
                topPadding: isSelectMode ? 0.0 : null,
                itemBuilder: (_, index, model) => GestureDetector(
                  onTap: isSelectMode
                      ? () => ref
                          .read(selectedMyViewLogProvider.notifier)
                          .toggleLog(model.id)
                      : () => context.go(
                            CustomRoutePath.myViewLogShortForm,
                            extra: index,
                          ),
                  child: ExplorationShortFormCard(
                    newsInfo: model.news.info.news,
                    isSelectMode: isSelectMode,
                    isSelected: selectedLogIds.contains(model.id),
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
            ),
            if (isSelectMode)
              Container(
                height: 50.0,
                color: ColorName.white000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final resp = await showConfirmationDialog(
                          context: context,
                          content: '모든 시청기록을 삭제하시겠어요?',
                          details: '삭제한 기록은 복구할 수 없어요',
                          confirmText: '삭제',
                          cancelText: '취소',
                        );

                        if (resp == true) {
                          final success = await ref
                              .read(myViewLogProvider.notifier)
                              .deleteAllLog();

                          if (!success) {
                            CustomToastMessage.showErrorToastMessage(
                              '시청기록 삭제에 실패했어요',
                            );
                            return;
                          }

                          CustomToastMessage.showSuccessToastMessage(
                            '시청기록이 모두 삭제되었어요',
                          );

                          ref
                              .read(selectedMyViewLogProvider.notifier)
                              .toggleSelectMode();
                        }
                      },
                      child: Text(
                        '전체 삭제',
                        style: CustomTextStyle.body3Medi(
                          color: ColorName.error500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: selectedLogIds.isNotEmpty
                          ? () async {
                              final resp = await showConfirmationDialog(
                                context: context,
                                content:
                                    '${selectedLogIds.length}개의 기록을 삭제하시겠어요?',
                                details: '삭제한 기록은 복구할 수 없어요',
                                confirmText: '삭제',
                                cancelText: '취소',
                              );

                              if (resp == true) {
                                final success = await ref
                                    .read(myViewLogProvider.notifier)
                                    .deleteSelectedLog(selectedLogIds);

                                if (!success) {
                                  CustomToastMessage.showErrorToastMessage(
                                    '시청기록 삭제에 실패했어요',
                                  );
                                  return;
                                }

                                CustomToastMessage.showSuccessToastMessage(
                                  '선택한 시청기록이 삭제되었어요',
                                );

                                ref
                                    .read(selectedMyViewLogProvider.notifier)
                                    .toggleSelectMode();
                              }
                            }
                          : null,
                      child: Text(
                        '선택 삭제',
                        style: CustomTextStyle.body3Medi(
                          color: selectedLogIds.isNotEmpty
                              ? ColorName.error500
                              : ColorName.gray100,
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
