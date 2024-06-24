import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/shorts/component/pause_button.dart';
import 'package:swm_kkokkomu_frontend/shorts/component/start_button.dart';
import 'package:video_player/video_player.dart';

const _floatingButtonSize = 36.0;
const _emojiDetailAnimationDuration = 350;

class SingleShorts extends StatefulWidget {
  final VideoPlayerController shortsController;

  const SingleShorts({
    super.key,
    required this.shortsController,
  });

  @override
  State<SingleShorts> createState() => _SingleShortsState();
}

class _SingleShortsState extends State<SingleShorts> {
  bool _isPauseButtonTapped = false;
  bool _isEmojiButtonTapped = false;
  bool _isEmojiDetailButtonVisible = false;
  Timer? _hidePauseButtonTimer;
  Timer? _hideEmojiDetailButtonTimer;
  final List<IconButton> _emojiButtonDetails = [
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

  @override
  void dispose() {
    _hidePauseButtonTimer?.cancel();
    _hideEmojiDetailButtonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.shortsController.value.isPlaying) {
          widget.shortsController.pause();
        } else {
          widget.shortsController.play();
        }

        _hidePauseButtonTimer?.cancel();
        _hidePauseButtonTimer = Timer(const Duration(milliseconds: 1100), () {
          if (mounted) {
            setState(() {
              _isPauseButtonTapped = false;
            });
          }
        });

        setState(() {
          _isPauseButtonTapped = true;
        });
      },
      onDoubleTap: _onEmojiButtonTap,
      child: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 9.0,
                height: 16.0,
                child: VideoPlayer(widget.shortsController),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      const Row(),
                      for (int i = 1; i <= _emojiButtonDetails.length; ++i)
                        AnimatedPositioned(
                          duration: const Duration(
                              milliseconds: _emojiDetailAnimationDuration),
                          right: _isEmojiButtonTapped ? i * 64.0 : 0.0,
                          child: Opacity(
                            opacity: _isEmojiDetailButtonVisible ? 1.0 : 0.0,
                            child: _emojiButtonDetails[i - 1],
                          ),
                        ),
                      IconButton(
                        onPressed: _onEmojiButtonTap,
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.white
                              .withOpacity(_isEmojiButtonTapped ? 0.5 : 1.0),
                          size: _floatingButtonSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: _floatingButtonSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.shortsController.value.isPlaying && _isPauseButtonTapped)
            const Center(
              child: StartButton(),
            ),
          if (!widget.shortsController.value.isPlaying && _isPauseButtonTapped)
            const Center(
              child: PauseButton(),
            ),
        ],
      ),
    );
  }

  void _onEmojiButtonTap() {
    _hideEmojiDetailButtonTimer?.cancel();
    if (_isEmojiButtonTapped) {
      _hideEmojiDetailButtonTimer = Timer(
          const Duration(milliseconds: _emojiDetailAnimationDuration), () {
        if (mounted) {
          setState(() {
            _isEmojiDetailButtonVisible = false;
          });
        }
      });
    } else {
      _isEmojiDetailButtonVisible = true;
    }

    setState(() {
      _isEmojiButtonTapped = !_isEmojiButtonTapped;
    });
  }
}
