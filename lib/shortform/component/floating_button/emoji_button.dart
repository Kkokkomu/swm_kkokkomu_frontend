import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/detail_emoji_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_info_provider.dart';

class EmojiButton extends ConsumerWidget {
  final bool isLoggedInUser;
  final int newsId;
  final ShortFormModel shortFormInfo;

  const EmojiButton({
    super.key,
    required this.isLoggedInUser,
    required this.newsId,
    required this.shortFormInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDetailEmojiButtonVisible =
        ref.watch(detailEmojiButtonVisibilityProvider(newsId));

    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 216.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: ColorName.white000,
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (ReactionType reactionType in ReactionType.values)
                  DetailEmojiButton(
                    isLoggedInUser: isLoggedInUser,
                    newsId: newsId,
                    shortFormInfo: shortFormInfo,
                    reactionType: reactionType,
                  ),
              ],
            ),
          )
              .animate(target: isDetailEmojiButtonVisible ? 1 : 0)
              .scaleXY(begin: 0, end: 1, duration: Duration.zero)
              .fadeIn(
                duration: AnimationDuration.emojiDetailAnimationDuration,
                curve: Curves.easeInOut,
              )
              .slideX(
                begin: 1.5,
                end: 0,
                duration: AnimationDuration.emojiDetailAnimationDuration,
                curve: Curves.easeInOut,
              ),
          CustomFloatingButton(
            width: 64.0,
            height: 64.0,
            icon: Assets.icons.svg.icGoodWhite.svg(),
            label: NumberFormat.compact(locale: 'ko_KR').format(
              shortFormInfo.reactionCnt.total,
            ),
            onTap: () => ref
                .read(detailEmojiButtonVisibilityProvider(newsId).notifier)
                .setDetailEmojiButtonVisibility(
                  !isDetailEmojiButtonVisible,
                ),
          ),
        ],
      ),
    );
  }
}

class DetailEmojiButton extends ConsumerWidget {
  final bool isLoggedInUser;
  final int newsId;
  final ShortFormModel shortFormInfo;
  final ReactionType reactionType;

  const DetailEmojiButton({
    super.key,
    required this.isLoggedInUser,
    required this.newsId,
    required this.shortFormInfo,
    required this.reactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userReactionType = shortFormInfo.userReaction.getReactionType();

    return CustomFloatingButton(
      isInkWell: false,
      width: 48.0,
      height: 64.0,
      shadowEnabled: false,
      icon: userReactionType == reactionType
          ? SvgPicture.asset(reactionType.blueSvgPath)
              .animate()
              .scaleXY(
                begin: 0.1,
                end: 1.0,
              )
              .shake(
                duration: const Duration(milliseconds: 400),
              )
              .then()
              .scaleXY(
                begin: 1.4,
                end: 1.1,
              )
              .shake(
                duration: const Duration(milliseconds: 400),
              )
          : SvgPicture.asset(reactionType.graySvgPath),
      label: NumberFormat.compact(locale: 'ko_KR').format(
        shortFormInfo.reactionCnt.getReactionCountByType(reactionType),
      ),
      labelColor: userReactionType == reactionType
          ? ColorName.gray500
          : ColorName.gray200,
      onTap: () {
        // 로그인 상태가 아닌 경우 이모지 버튼 닫고 로그인 모달창 띄우기
        if (!isLoggedInUser) {
          ref
              .read(detailEmojiButtonVisibilityProvider(newsId).notifier)
              .setDetailEmojiButtonVisibility(false);
          showLoginModalBottomSheet(context);
          return;
        }

        // 로그인 상태인 경우 반응 정보 업데이트
        // 이미 해당 이모지를 누른 상태인 경우 반응 삭제
        userReactionType == reactionType
            ? ref
                .read(loggedInUserShortFormInfoProvider(newsId).notifier)
                .deleteReaction(reactionType: reactionType)
            : ref
                .read(loggedInUserShortFormInfoProvider(newsId).notifier)
                .putPostReaction(
                  reactionType: reactionType,
                  // userReactionType가 null인 경우는 어떠한 감정표현도 하지 않은 상태
                  // userReactionType가 null이 아닌 경우는 이미 다른 이모지를 누른 상태
                  isReacted: userReactionType != null,
                );
      },
    );
  }
}
