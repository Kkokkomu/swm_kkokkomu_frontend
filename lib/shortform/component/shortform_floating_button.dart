import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/detail_emoji_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _floatingButtonSize = 36.0;
const _emojiDetailAnimationDuration = Duration(milliseconds: 300);

class EmojiButton extends ConsumerWidget {
  final int newsId;

  const EmojiButton({
    super.key,
    required this.newsId,
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
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                    Icon(
                      Icons.sentiment_very_dissatisfied_outlined,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                    Icon(
                      Icons.sentiment_very_satisfied_outlined,
                      color: Colors.white,
                      size: _floatingButtonSize,
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
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => ref
                    .read(detailEmojiButtonVisibilityProvider(newsId).notifier)
                    .setDetailEmojiButtonVisibility(
                      !isDetailEmojiButtonVisible,
                    ),
                icon: const Icon(
                  Icons.emoji_emotions,
                  color: Colors.white,
                  size: _floatingButtonSize,
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
    return IconButton(
      onPressed: () {
        ref
            .read(shortFormCommentHeightControllerProvider(newsId).notifier)
            .setCommentBodySizeMedium(maxCommentHeight);
      },
      icon: const Icon(
        Icons.comment,
        color: Colors.white,
        size: _floatingButtonSize,
      ),
    );
  }
}

class ShareYoutubeUrlButton extends StatelessWidget {
  final String shortFormYoutubeURL;

  const ShareYoutubeUrlButton({
    super.key,
    required this.shortFormYoutubeURL,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Share.shareUri(
          Uri.parse(shortFormYoutubeURL),
        );
      },
      icon: const Icon(
        Icons.share,
        color: Colors.white,
        size: _floatingButtonSize,
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
    return IconButton(
      onPressed: () {
        launchUrl(
          Uri.parse(shortFormRelatedURL),
        );
      },
      icon: const Icon(
        Icons.newspaper,
        color: Colors.white,
        size: _floatingButtonSize,
      ),
    );
  }
}
