import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_list_view.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_card.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/guest_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/logged_in_user_shortform_comment_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/provider/guest_user_shortform_reply_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/provider/logged_in_user_shortform_reply_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentBody extends StatelessWidget {
  final int newsId;
  final bool isReply;
  final int? parentCommentId;

  const ShortFormCommentBody({
    super.key,
    required this.newsId,
    required this.isReply,
    required this.parentCommentId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (_, ref, __) {
          final user = ref.watch(userInfoProvider);
          final isShortFormCommentCreated = ref.watch(
              shortFormCommentHeightControllerProvider(newsId)
                  .select((value) => value.isShortFormCommentCreated));

          // 댓글창이 생성되지 않은 경우 댓글 리스트를 보여주지 않음
          if (!isShortFormCommentCreated) {
            return const SizedBox();
          }

          late final AutoDisposeStateNotifierProviderFamily<
              CursorPaginationProvider<IModelWithId,
                  IBaseCursorPaginationRepository<IModelWithId>>,
              CursorPaginationBase,
              int> provider;

          // 대댓글이 아닌 댓글인 경우 댓글 리스트를 보여줌
          if (!isReply) {
            if (user is UserModel) {
              provider = loggedInUserShortFormCommentProvider;
            } else {
              provider = guestUserShortFormCommentProvider;
            }

            return CursorPaginationListView<ShortFormCommentModel>(
              id: newsId,
              provider: provider,
              separatorBuilder: (_, __) => const SizedBox(height: 16.0),
              itemBuilder: (_, index, model) => ShortFormCommentCard(
                shortFormCommentModel: model,
                parentCommentId: isReply ? parentCommentId : null,
                index: index,
                isReply: isReply,
                isReplyHeader: false,
              ),
            );
          }

          // 댓글이 아닌 대댓글인 경우 대댓글 리스트를 보여줌
          if (user is UserModel) {
            provider = loggedInUserShortFormReplyProvider;
          } else {
            provider = guestUserShortFormReplyProvider;
          }

          return Consumer(
            builder: (_, ref, child) {
              // 대댓글인 경우 부모 댓글 정보를 가져옴
              final parentComment = ref.watch(
                loggedInUserShortFormCommentProvider(newsId).select(
                  (value) {
                    final parentCommentState =
                        (value as CursorPagination<ShortFormCommentModel>);

                    final parentCommentIndex = parentCommentState.items
                        .indexWhere((element) => element.id == parentCommentId);

                    if (parentCommentIndex == -1) {
                      return (index: parentCommentIndex, model: null);
                    }

                    return (
                      index: parentCommentIndex,
                      model: parentCommentState.items[parentCommentIndex],
                    );
                  },
                ),
              );

              // 부모 댓글이 삭제/차단된 경우 대댓글 리스트를 보여주지 않음
              if (parentComment.model == null) {
                // 대댓글 삭제/차단된 경우 대댓글 창을 닫음
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ref
                      .read(shortFormCommentHeightControllerProvider(newsId)
                          .notifier)
                      .deactivateReply(),
                );

                return const Center(
                  child: Text('댓글이 삭제/차단되었습니다.'),
                );
              }

              final scrollController = ScrollController();

              return NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (_, __) {
                  return [
                    // 부모 댓글 정보를 보여줌
                    SliverToBoxAdapter(
                      child: Container(
                        color: ColorName.gray100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ShortFormCommentCard(
                            shortFormCommentModel: parentComment.model!,
                            index: parentComment.index,
                            isReply: false,
                            isReplyHeader: true,
                            parentCommentId: null,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: CursorPaginationListView<ShortFormCommentModel>(
                  id: parentCommentId!,
                  provider: provider,
                  separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                  itemBuilder: (_, index, model) => ShortFormCommentCard(
                    shortFormCommentModel: model,
                    parentCommentId: isReply ? parentCommentId : null,
                    index: index,
                    isReply: isReply,
                    isReplyHeader: false,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
