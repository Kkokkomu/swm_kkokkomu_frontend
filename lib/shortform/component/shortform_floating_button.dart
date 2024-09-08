import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/detail_emoji_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _floatingButtonSize = 36.0;
const _emojiDetailAnimationDuration = Duration(milliseconds: 300);

class EmojiButton extends ConsumerWidget {
  final int newsId;
  final int newsIndex;
  final ShortFormReactionCountInfo reactionCountInfo;
  final ReactionType? userReactionType;

  const EmojiButton({
    super.key,
    required this.newsId,
    required this.newsIndex,
    required this.reactionCountInfo,
    required this.userReactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDetailEmojiButtonVisible =
        ref.watch(detailEmojiButtonVisibilityProvider(newsId));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 220,
                decoration: BoxDecoration(
                  color: ColorName.white000,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (ReactionType reactionType in ReactionType.values)
                      DetailEmojiButton(
                        newsId: newsId,
                        newsIndex: newsIndex,
                        reactionCountInfo: reactionCountInfo,
                        reactionType: reactionType,
                        userReactionType: userReactionType,
                      ),
                  ],
                ),
              )
                  .animate(target: isDetailEmojiButtonVisible ? 1 : 0)
                  .scaleXY(begin: 0, end: 1, duration: Duration.zero)
                  .fadeIn(
                    duration: _emojiDetailAnimationDuration,
                    curve: Curves.easeInOut,
                  )
                  .slideX(
                    begin: 1.5,
                    end: 0,
                    duration: _emojiDetailAnimationDuration,
                    curve: Curves.easeInOut,
                  ),
              CustomFloatingButton(
                icon: Assets.icons.svg.icGoodWhite.svg(),
                label: reactionCountInfo.total.toString(),
                onTap: () => ref
                    .read(detailEmojiButtonVisibilityProvider(newsId).notifier)
                    .setDetailEmojiButtonVisibility(
                      !isDetailEmojiButtonVisible,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}

class DetailEmojiButton extends ConsumerWidget {
  final int newsId;
  final int newsIndex;
  final ShortFormReactionCountInfo reactionCountInfo;
  final ReactionType reactionType;
  final ReactionType? userReactionType;

  const DetailEmojiButton({
    super.key,
    required this.newsId,
    required this.newsIndex,
    required this.reactionCountInfo,
    required this.reactionType,
    required this.userReactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFloatingButton(
      icon: userReactionType == reactionType
          ? SvgPicture.asset(reactionType.getBlueSvgPath())
              .animate()
              .scaleXY(
                begin: 0.1,
                end: 1.0,
              )
              .shake()
              .then()
              .scaleXY(
                begin: 1.2,
                end: 1.1,
              )
              .shake()
          : SvgPicture.asset(reactionType.getGraySvgPath()),
      label: reactionCountInfo.getReactionCountByType(reactionType).toString(),
      labelColor: Colors.black,
      onTap: () {
        // 로그인 상태가 아닌 경우 이모지 버튼 닫고 로그인 모달창 띄우기
        if (ref.read(userInfoProvider) is! UserModel) {
          ref
              .read(detailEmojiButtonVisibilityProvider(newsId).notifier)
              .setDetailEmojiButtonVisibility(false);
          showLoginModalBottomSheet(context, ref);
          return;
        }

        // 로그인 상태인 경우 반응 정보 업데이트
        // 이미 해당 이모지를 누른 상태인 경우 반응 삭제
        userReactionType == reactionType
            ? ref.read(loggedInUserShortFormProvider.notifier).deleteReaction(
                  newsId: newsId,
                  newsIndex: newsIndex,
                  reactionType: reactionType,
                )
            : ref.read(loggedInUserShortFormProvider.notifier).postReaction(
                  newsId: newsId,
                  newsIndex: newsIndex,
                  reactionType: reactionType,
                );
      },
    );
  }
}

class CommentButton extends StatelessWidget {
  final WidgetRef ref;
  final int newsId;
  final double maxCommentHeight;

  const CommentButton({
    super.key,
    required this.ref,
    required this.newsId,
    required this.maxCommentHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.comment,
        color: Colors.white,
      ),
      label: '댓글',
      onTap: () => ref
          .read(shortFormCommentHeightControllerProvider(newsId).notifier)
          .setCommentBodySizeMedium(maxCommentHeight),
    );
  }
}

class ShareButton extends StatelessWidget {
  final String shareUrl;

  const ShareButton({
    super.key,
    required this.shareUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
      ),
      label: '공유',
      onTap: () => Share.shareUri(
        Uri.parse(shareUrl),
      ),
    );
  }
}

class RelatedUrlButton extends StatelessWidget {
  final String shortFormRelatedURL;

  const RelatedUrlButton({
    super.key,
    required this.shortFormRelatedURL,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.newspaper,
        color: Colors.white,
      ),
      label: '관련기사',
      onTap: () async {
        final url = await canLaunchUrl(Uri.parse(shortFormRelatedURL))
            ? shortFormRelatedURL
            : Constants.relatedUrlOnError;

        launchUrl(
          Uri.parse(url),
        );
      },
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.tune,
        color: Colors.white,
      ),
      onTap: () {},
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      onTap: () {},
    );
  }
}

class MoreInfoButton extends StatelessWidget {
  const MoreInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
        size: _floatingButtonSize,
      ),
      offset: const Offset(0, _floatingButtonSize + 16.0),
      itemBuilder: (_) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: Text('설명보기'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          child: Text('관심없어요'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          child: Text('신고하기'),
        ),
      ],
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final Color labelColor;
  final void Function()? onTap;

  const CustomFloatingButton({
    super.key,
    required this.icon,
    this.label,
    this.labelColor = ColorName.white000,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: _floatingButtonSize,
            height: _floatingButtonSize,
            child: FittedBox(child: icon),
          ),
        ),
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 12.0,
              color: labelColor,
            ),
          ),
      ],
    );
  }
}
