import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/cursor_pagination_list_view.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_error_widget.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
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

class ShortFormCommentBody extends StatefulWidget {
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
  State<ShortFormCommentBody> createState() => _ShortFormCommentBodyState();
}

class _ShortFormCommentBodyState extends State<ShortFormCommentBody> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (_, ref, __) {
          final user = ref.watch(userInfoProvider);
          final isShortFormCommentCreated = ref.watch(
              shortFormCommentHeightControllerProvider(widget.newsId)
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
          if (!widget.isReply) {
            if (user is UserModel) {
              provider = loggedInUserShortFormCommentProvider;
            } else {
              provider = guestUserShortFormCommentProvider;
            }

            return CursorPaginationListView<ShortFormCommentModel>(
              scrollController: _scrollController,
              id: widget.newsId,
              provider: provider,
              separatorBuilder: (_, __) => const SizedBox(),
              itemBuilder: (_, index, model) => ShortFormCommentCard(
                shortFormCommentModel: model,
                parentCommentId: widget.isReply ? widget.parentCommentId : null,
                index: index,
                isReply: widget.isReply,
                isReplyHeader: false,
              ),
              emptyWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.svg.imgCommentEmpty.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '작성된 댓글이 없어요',
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
                      .read(provider(widget.newsId).notifier)
                      .paginate(forceRefetch: true),
                ),
              ),
              fetchingMoreErrorWidget: CustomErrorWidget(
                errorText: '댓글을 더 불러오는 중 오류가 발생했어요',
                firstButtonText: '더 불러오기',
                secondButtonText: '새로고침',
                onFirstButtonTap: () => ref
                    .read(provider(widget.newsId).notifier)
                    .paginate(fetchMore: true),
                onSecondButtonTap: () => ref
                    .read(provider(widget.newsId).notifier)
                    .paginate(forceRefetch: true),
                bottomPadding: 18.0,
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
              final parentCommentProvider = user is UserModel
                  ? loggedInUserShortFormCommentProvider(widget.newsId)
                  : guestUserShortFormCommentProvider(widget.newsId);

              final parentComment = ref.watch(
                parentCommentProvider.select(
                  (value) {
                    // 부모 댓글이 CursorPagination<ShortFormCommentModel>이 아닌 경우
                    // 대댓글 모델로 null을 반환하고 대댓글 리스트를 닫음
                    if (value is! CursorPagination<ShortFormCommentModel>) {
                      return (index: -1, model: null);
                    }

                    final parentCommentState = value;

                    final parentCommentIndex = parentCommentState.items
                        .indexWhere(
                            (element) => element.id == widget.parentCommentId);

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
              // 대댓글 숫자가 바뀐 경우 부모 댓글의 replyCnt값을 업데이트
              // 이때 대댓글 페이지가 마지막 페이지인 경우에만 업데이트 (모든 대댓글을 불러온 경우)
              ref.listen(
                provider(widget.parentCommentId!),
                (_, next) {
                  if (next is CursorPagination<ShortFormCommentModel> &&
                      next.pageInfo.isLast) {
                    if (user is UserModel) {
                      ref
                          .read(loggedInUserShortFormCommentProvider(
                                  widget.newsId)
                              .notifier)
                          .setReplyCnt(
                            commentId: widget.parentCommentId!,
                            cnt: next.items.length,
                          );
                    } else {
                      ref
                          .read(guestUserShortFormCommentProvider(widget.newsId)
                              .notifier)
                          .setReplyCnt(
                            commentId: widget.parentCommentId!,
                            cnt: next.items.length,
                          );
                    }
                  }
                },
              );

              // 부모 댓글이 삭제/차단된 경우 대댓글 리스트를 보여주지 않음
              if (parentComment.model == null) {
                // 대댓글 삭제/차단된 경우 대댓글 창을 닫음
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ref
                      .read(shortFormCommentHeightControllerProvider(
                              widget.newsId)
                          .notifier)
                      .deactivateReply(),
                );

                return Center(
                  child: Text(
                    '댓글이 삭제/차단되었어요',
                    style: CustomTextStyle.body1Medi(color: ColorName.gray200),
                  ),
                );
              }

              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (_, __) {
                  return [
                    // 부모 댓글 정보를 보여줌
                    SliverToBoxAdapter(
                      child: Container(
                        color: ColorName.gray50,
                        child: ShortFormCommentCard(
                          shortFormCommentModel: parentComment.model!,
                          index: parentComment.index,
                          isReply: false,
                          isReplyHeader: true,
                          parentCommentId: null,
                        ),
                      ),
                    ),
                  ];
                },
                body: CursorPaginationListView<ShortFormCommentModel>(
                  id: widget.parentCommentId!,
                  provider: provider,
                  separatorBuilder: (_, __) => const SizedBox(),
                  itemBuilder: (_, index, model) => ShortFormCommentCard(
                    shortFormCommentModel: model,
                    parentCommentId:
                        widget.isReply ? widget.parentCommentId : null,
                    index: index,
                    isReply: widget.isReply,
                    isReplyHeader: false,
                  ),
                  emptyWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.svg.imgCommentEmpty.svg(),
                      const SizedBox(height: 6.0),
                      Text(
                        '작성된 대댓글이 없어요',
                        style:
                            CustomTextStyle.body1Medi(color: ColorName.gray200),
                      ),
                    ],
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
