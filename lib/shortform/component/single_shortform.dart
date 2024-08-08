import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_comment.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_pause_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_start_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shorts_comment_provider.dart';

class SingleShortForm extends ConsumerStatefulWidget {
  final ShortFormModel shortForm;

  const SingleShortForm({
    super.key,
    required this.shortForm,
  });

  @override
  ConsumerState<SingleShortForm> createState() => _SingleShortsState();
}

class _SingleShortsState extends ConsumerState<SingleShortForm> {
  late BetterPlayerController _betterPlayerController;
  bool _isPauseButtonTapped = false;
  Timer? _hidePauseButtonTimer;
  Timer? _hideEmojiDetailButtonTimer;
  bool _isVideoError = false;

  @override
  void initState() {
    super.initState();
    setUpVideo();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose(forceDispose: true);
    _hidePauseButtonTimer?.cancel();
    _hideEmojiDetailButtonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortsCommentVisibility = ref.watch(
      shortsCommentVisibilityProvider(widget.shortForm.shortformList!.id!),
    );

    final shortFormID = widget.shortForm.shortformList!.id!;
    // final shortFormYoutubeURL = widget.shortForm.shortForm!.youtubeUrl;
    // final shortFormRelatedURL = widget.shortForm.shortForm!.relatedUrl;

    if (_isVideoError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '비디오 에러 발생',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              _isVideoError = false;
              setUpVideo();
              setState(() {});
            },
            child: const Text('재시도'),
          ),
        ],
      );
    }

    if (!_betterPlayerController.isVideoInitialized()!) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      top: shortsCommentVisibility.isShortsCommentVisible,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    // 숏폼 화면을 누를때
                    onTap: () {
                      // 비디오가 초기화 되지 않았을 때는 아무것도 하지 않음
                      if (!(_betterPlayerController.isVideoInitialized() ==
                          true)) {
                        return;
                      }

                      // 댓글창이 보이는 상태에서 숏폼 화면을 누르면 댓글창 닫음
                      if (shortsCommentVisibility.isShortsCommentVisible) {
                        ref
                            .read(shortsCommentVisibilityProvider(shortFormID)
                                .notifier)
                            .toggleShortsCommentVisibility();

                        return;
                      }

                      // 비디오가 초기화 되었을 때는 플레이/일시정지 토글
                      togglePausePlay();
                    },
                    // 댓글창이 보이는 상태에서는 드래그시 아무것도 하지 않음
                    // 댓글창이 보이지 않는 상태에서는 드래그시 PageView 드래그 작동
                    onVerticalDragStart:
                        shortsCommentVisibility.isShortsCommentVisible
                            ? (_) {}
                            : null,
                    behavior: HitTestBehavior.opaque,
                    child: IgnorePointer(
                      child: BetterPlayer(
                        controller: _betterPlayerController,
                      ),
                    ),
                  ),
                  // 비디오가 초기화 되지 않았을 때는 플로팅 버튼들이 보이지 않음
                  // 댓글창이 보이는 상태에서는 플로팅 버튼들이 보이지 않음
                  if (_betterPlayerController.isVideoInitialized() == true &&
                      !shortsCommentVisibility.isShortsCommentVisible)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const EmojiButton(),
                            const SizedBox(height: 16.0),
                            CommentButton(
                              ref: ref,
                              shortFormID: shortFormID,
                            ),
                            // const SizedBox(height: 16.0),
                            // ShareYoutubeUrlButton(
                            //   shortFormYoutubeURL: shortFormYoutubeURL!,
                            // ),
                            // const SizedBox(height: 16.0),
                            // RelatedUrlButton(
                            //   shortFormRelatedURL: shortFormRelatedURL!,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  if (_betterPlayerController.isVideoInitialized() == true &&
                      _betterPlayerController.isPlaying()! &&
                      _isPauseButtonTapped)
                    const Center(
                      child: ShortFormStartButton(),
                    ),
                  if (_betterPlayerController.isVideoInitialized() == true &&
                      !_betterPlayerController.isPlaying()! &&
                      _isPauseButtonTapped)
                    const Center(
                      child: ShortFormPauseButton(),
                    ),
                ],
              ),
            ),
            if (shortsCommentVisibility.isShortsCommentTapped)
              ShortFormComment(
                parentHeight: constraints.maxHeight,
                newsID: shortFormID,
              ),
          ],
        );
      }),
    );
  }

  void setUpVideo() async {
    final customBetterPlayerConfiguration = BetterPlayerConfiguration(
      playerVisibilityChangedBehavior: onVisibilityChanged,
      fit: BoxFit.fitHeight,
      aspectRatio: 1 / 10,
      looping: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        showControls: false,
      ),
    );
    _betterPlayerController = BetterPlayerController(
      customBetterPlayerConfiguration,
    );

    try {
      await _betterPlayerController.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.shortForm.shortformList!.shortformUrl!,
          cacheConfiguration: customBetterPlayerCacheConfiguration,
          bufferingConfiguration: customBetterPlayerBufferingConfiguration,
        ),
      );
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print(error);
      _betterPlayerController.dispose(forceDispose: true);
      setState(() {
        _isVideoError = true;
      });
    }
  }

  void togglePausePlay() {
    if (_betterPlayerController.isPlaying()!) {
      _betterPlayerController.pause();
    } else {
      _betterPlayerController.play();
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
  }

  void onVisibilityChanged(double visibleFraction) {
    if (visibleFraction == 1.0) {
      _betterPlayerController.play();
      return;
    }
    if (visibleFraction == 0.0 &&
        _betterPlayerController.isVideoInitialized()! &&
        !ref
            .read(shortsCommentVisibilityProvider(
                widget.shortForm.shortformList!.id!))
            .isShortsCommentVisible) {
      _betterPlayerController.pause();
      _betterPlayerController.seekTo(const Duration(seconds: 0));
      return;
    }
  }
}
