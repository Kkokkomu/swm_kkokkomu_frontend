import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_list_view_by_provider.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_error_widget.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/my_log/component/my_comment_log_card.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_comment_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/my_comment_log_provider.dart';

class MyCommentLogScreen extends ConsumerWidget {
  static String get routeName => 'my-comment-log';

  const MyCommentLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: ColorName.white000,
      systemNavigationBarIconBrightness: Brightness.dark,
      title: '내 댓글',
      onBackButtonPressed: () => context.pop(),
      child: CursorPaginationListViewByProvider<MyCommentLogModel>(
        provider: myCommentLogProvider,
        separatorBuilder: (_, __) => const SizedBox(height: 4.0),
        itemBuilder: (_, index, model) => Padding(
          padding:
              EdgeInsets.fromLTRB(18.0, index == 0 ? 24.0 : 12.0, 8.0, 12.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.go(
              CustomRoutePath.myCommentLogShortForm,
              extra: {
                GoRouterExtraKeys.newsId: model.news.info.news.id,
                GoRouterExtraKeys.shortFormUrl:
                    model.news.info.news.shortformUrl,
              },
            ),
            child: MyCommentLogCard(
              index: index,
              commentLogModel: model,
            ),
          ),
        ),
        emptyWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.svg.imgCommentEmpty.svg(),
            const SizedBox(height: 6.0),
            Text(
              '작성한 댓글이 없어요',
              style: CustomTextStyle.body1Medi(color: ColorName.gray200),
            ),
          ],
        ),
        errorWidget: Center(
          child: CustomErrorWidget(
            errorIcon: Assets.images.svg.imgCommentEmpty.svg(),
            errorText: '댓글을 불러오는 중 오류가 발생했어요',
            firstButtonText: '댓글 다시 불러오기',
            onFirstButtonTap: () => ref
                .read(myCommentLogProvider.notifier)
                .paginate(forceRefetch: true),
          ),
        ),
        fetchingMoreErrorWidget: CustomErrorWidget(
          errorText: '댓글을 더 불러오는 중 오류가 발생했어요',
          firstButtonText: '더 불러오기',
          secondButtonText: '새로고침',
          onFirstButtonTap: () =>
              ref.read(myCommentLogProvider.notifier).paginate(fetchMore: true),
          onSecondButtonTap: () => ref
              .read(myCommentLogProvider.notifier)
              .paginate(forceRefetch: true),
          bottomPadding: 18.0,
        ),
      ),
    );
  }
}
