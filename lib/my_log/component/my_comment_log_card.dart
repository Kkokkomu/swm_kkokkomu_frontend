import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_comment_log_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyCommentLogCard extends ConsumerWidget {
  final int index;
  final MyCommentLogModel commentLogModel;

  const MyCommentLogCard({
    super.key,
    required this.index,
    required this.commentLogModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 48.0,
                height: 48.0,
                imageUrl: commentLogModel.news.info.news.thumbnail ?? '',
                // 가로 높이보다 세로 높이가 큰 숏폼 섬네일이므로
                // 가로 너비를 기준으로 섬네일을 불러온다
                memCacheWidth:
                    (48.0 * MediaQuery.of(context).devicePixelRatio).round(),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                placeholder: (_, __) => Skeletonizer(
                  effect: const SoldColorEffect(
                    color: ColorName.gray100,
                  ),
                  child: Container(
                    color: Colors.black,
                    width: 48.0,
                    height: 48.0,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: ColorName.gray100,
                  width: 48.0,
                  height: 48.0,
                  child: const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2.0),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    commentLogModel.news.info.news.title,
                    style: CustomTextStyle.detail1Medi(),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    commentLogModel.news.info.news.createdAt.year ==
                            Constants.unknownErrorDateTimeYear
                        ? Constants.unknownErrorString
                        : DateFormat('yyyy.MM.dd', 'ko_KR')
                            .format(commentLogModel.news.info.news.createdAt),
                    style: CustomTextStyle.detail3Reg(color: ColorName.gray200),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 36.0),
                  Assets.icons.svg.icCommentHistory.svg(),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          commentLogModel.comment.content,
                          style: CustomTextStyle.detail1Medi(),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          commentLogModel.comment.editedAt.year ==
                                  Constants.unknownErrorDateTimeYear
                              ? Constants.unknownErrorString
                              : DateFormat('yyyy.MM.dd', 'ko_KR').format(
                                  commentLogModel.comment.editedAt,
                                ),
                          style: CustomTextStyle.detail3Reg(
                            color: ColorName.gray200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              padding: EdgeInsets.zero,
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              offset: const Offset(0.0, 41.0),
              menuPadding: EdgeInsets.zero,
              icon: Assets.icons.svg.btnCommentMenu.svg(),
              surfaceTintColor: ColorName.white000,
              color: ColorName.white000,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              onSelected: (value) async {
                final user = ref.read(userInfoProvider);

                // 로그인된 사용자가 아닌 경우 잘못된 접근이므로 현재 화면을 pop하고 리턴
                if (user is! UserModel) {
                  context.pop();
                  return;
                }

                switch (value) {
                  case ShortFormCommentPopupType.update:
                    // 댓글 수정 바텀시트 띄우기
                    final controller = TextEditingController(
                      text: commentLogModel.comment.content,
                    );

                    // showShortFormCommentInputBottomSheet(
                    //   context: context,
                    //   newsId: shortFormCommentModel.comment.newsId,
                    //   parentCommentId: isReply ? parentCommentId : null,
                    //   commentId: shortFormCommentModel.id,
                    //   index: index,
                    //   controller: controller,
                    //   type: isReply
                    //       ? ShortFormCommentSendButtonType.replyUpdate
                    //       : ShortFormCommentSendButtonType.update,
                    // );
                    return;

                  case ShortFormCommentPopupType.delete:
                    // 댓글 삭제 여부 확인 다이얼로그
                    final isDelete = await showConfirmationDialog(
                      context: context,
                      content: '정말 댓글을 삭제하시겠어요?',
                      details: '삭제된 댓글은 복구할 수 없어요',
                      confirmText: '삭제',
                      cancelText: '취소',
                    );

                    // 사용자가 삭제를 선택하지 않은 경우 리턴
                    if (isDelete != true) {
                      return;
                    }

                    // 사용자가 삭제를 선택한 경우 댓글 삭제 요청
                    // 댓글 삭제와 대댓글 삭제 구분
                    // parentId가 있는 경우 대댓글 삭제, 없는 경우 댓글 삭제
                    // final resp = switch (model.comment.parentId != null) {
                    //   true => await ref
                    //       .read(
                    //         loggedInUserShortFormReplyProvider(
                    //                 parentCommentId!)
                    //             .notifier,
                    //       )
                    //       .deleteReply(
                    //         newsId: shortFormCommentModel.comment.newsId,
                    //         replyId: shortFormCommentModel.id,
                    //         index: index,
                    //       ),
                    //   false => await ref
                    //       .read(
                    //         loggedInUserShortFormCommentProvider(
                    //           shortFormCommentModel.comment.newsId,
                    //         ).notifier,
                    //       )
                    //       .deleteComment(
                    //         commentId: shortFormCommentModel.id,
                    //         index: index,
                    //       )
                    // };

                    // 삭제 실패 시 에러 메시지 출력
                    // if (resp == false) {
                    //   CustomToastMessage.showErrorToastMessage(
                    //       '댓글 삭제에 실패했습니다.');
                    //   return;
                    // }

                    // 삭제 성공 시 성공 메시지 출력
                    // CustomToastMessage.showSuccessToastMessage(
                    //     '댓글이 삭제되었습니다.');
                    return;

                  default:
                    return;
                }
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  height: 40.0,
                  value: ShortFormCommentPopupType.update,
                  child: Center(
                    child: Row(
                      children: [
                        Assets.icons.svg.icEdit.svg(),
                        const SizedBox(width: 2.0),
                        Text(
                          '수정하기',
                          style: CustomTextStyle.detail1Reg(),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  height: 40.0,
                  value: ShortFormCommentPopupType.delete,
                  child: Center(
                    child: Row(
                      children: [
                        Assets.icons.svg.icDelete.svg(),
                        const SizedBox(width: 2.0),
                        Text(
                          '삭제하기',
                          style: CustomTextStyle.detail1Reg(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}