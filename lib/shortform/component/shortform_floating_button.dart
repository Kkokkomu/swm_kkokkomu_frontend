import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _floatingButtonSize = 36.0;
const _emojiDetailAnimationDuration = 350;

final List<IconButton> emojiButtonDetails = [
  IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.emoji_emotions,
      color: Colors.white,
      size: _floatingButtonSize,
    ),
  ),
  IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.sentiment_very_dissatisfied,
      color: Colors.white,
      size: _floatingButtonSize,
    ),
  ),
  IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.sentiment_very_dissatisfied_outlined,
      color: Colors.white,
      size: _floatingButtonSize,
    ),
  ),
  IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.sentiment_very_satisfied_outlined,
      color: Colors.white,
      size: _floatingButtonSize,
    ),
  ),
];

class EmojiButton extends StatefulWidget {
  const EmojiButton({super.key});

  @override
  State<EmojiButton> createState() => _EmojiButtonState();
}

class _EmojiButtonState extends State<EmojiButton> {
  bool isEmojiButtonTapped = false;
  bool isEmojiDetailButtonVisible = false;
  Timer? hideEmojiDetailButtonTimer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        const Row(),
        for (int i = 1; i <= emojiButtonDetails.length; ++i)
          AnimatedPositioned(
            duration:
                const Duration(milliseconds: _emojiDetailAnimationDuration),
            right: isEmojiButtonTapped ? i * 64.0 : 0.0,
            child: Opacity(
              opacity: isEmojiDetailButtonVisible ? 1.0 : 0.0,
              child: emojiButtonDetails[i - 1],
            ),
          ),
        IconButton(
          onPressed: onEmojiButtonTap,
          icon: Icon(
            Icons.emoji_emotions,
            color: Colors.white.withOpacity(isEmojiButtonTapped ? 0.5 : 1.0),
            size: _floatingButtonSize,
          ),
        ),
      ],
    );
  }

  void onEmojiButtonTap() {
    hideEmojiDetailButtonTimer?.cancel();
    if (isEmojiButtonTapped) {
      hideEmojiDetailButtonTimer = Timer(
          const Duration(milliseconds: _emojiDetailAnimationDuration), () {
        if (mounted) {
          setState(() {
            isEmojiDetailButtonVisible = false;
          });
        }
      });
    } else {
      isEmojiDetailButtonVisible = true;
    }

    setState(() {
      isEmojiButtonTapped = !isEmojiButtonTapped;
    });
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
