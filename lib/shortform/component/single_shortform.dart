import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_pause_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_start_button.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_box.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_visibility_provider.dart';

class SingleShortForm extends ConsumerStatefulWidget {
  static const Duration _seekBackTime = Duration(seconds: 1);

  final int newsId;
  final String shortFormUrl;

  const SingleShortForm({
    super.key,
    required this.newsId,
    required this.shortFormUrl,
  });

  @override
  ConsumerState<SingleShortForm> createState() => _SingleShortFormState();
}

class _SingleShortFormState extends ConsumerState<SingleShortForm> {
  late BetterPlayerController _betterPlayerController;
  bool _isPauseButtonTapped = false;
  Timer? _hidePauseButtonTimer;
  Timer? _hideEmojiDetailButtonTimer;
  bool _isVideoError = false;
  bool _autoPlay = true;

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
    final shortFormVisibility =
        ref.watch(shortFormCommentVisibilityProvider(widget.newsId));

    if (_isVideoError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '비디오 에러 발생',
            style: TextStyle(
              color: Colors.black,
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

    if (_betterPlayerController.isVideoInitialized() != true) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    }

    return SafeArea(
      top: shortFormVisibility.isShortFormCommentVisible,
      child:
          LayoutBuilder(builder: (BuildContext _, BoxConstraints constraints) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    // 숏폼 화면을 누를때
                    onTap: () {
                      // 비디오가 초기화 되지 않았을 때는 아무것도 하지 않음
                      if (_betterPlayerController.isVideoInitialized() !=
                          true) {
                        return;
                      }

                      // 댓글창이 보이는 상태에서 숏폼 화면을 누르면 댓글창 닫음
                      if (shortFormVisibility.isShortFormCommentVisible) {
                        ref
                            .read(shortFormCommentHeightControllerProvider(
                                    widget.newsId)
                                .notifier)
                            .setCommentBodySizeSmall();

                        return;
                      }

                      // 비디오가 초기화 되었을 때는 플레이/일시정지 토글
                      togglePausePlay();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: IgnorePointer(
                      child: BetterPlayer(
                        controller: _betterPlayerController,
                      ),
                    ),
                  ),
                  // 비디오가 초기화 되지 않았을 때는 플로팅 버튼들이 보이지 않음
                  // 댓글이 보이는 상태에서는 플로팅 버튼들이 보이지 않음
                  if (_betterPlayerController.isVideoInitialized() == true &&
                      !shortFormVisibility.isShortFormCommentVisible)
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
                              newsId: widget.newsId,
                              maxCommentHeight: constraints.maxHeight,
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
                      _betterPlayerController.isPlaying() == true &&
                      _isPauseButtonTapped)
                    const Center(
                      child: ShortFormStartButton(),
                    ),
                  if (_betterPlayerController.isVideoInitialized() == true &&
                      _betterPlayerController.isPlaying() == false &&
                      _isPauseButtonTapped)
                    const Center(
                      child: ShortFormPauseButton(),
                    ),
                ],
              ),
            ),
            ShortFormCommentBox(
              newsId: widget.newsId,
              maxShortFormCommentBoxHeight: constraints.maxHeight,
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
          widget.shortFormUrl,
          cacheConfiguration: customBetterPlayerCacheConfiguration,
          bufferingConfiguration: customBetterPlayerBufferingConfiguration,
        ),
      );
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('에러 비디오: ${widget.shortFormUrl}');
      _betterPlayerController.dispose(forceDispose: true);
      setState(() {
        _isVideoError = true;
      });
    }
  }

  void togglePausePlay() {
    if (_betterPlayerController.isPlaying() == true) {
      _betterPlayerController.pause();
    } else {
      _betterPlayerController.play();
    }

    _hidePauseButtonTimer?.cancel();
    _hidePauseButtonTimer =
        Timer(AnimationDuration.startPauseButtonTotalDuration, () {
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
    final isCommentVisible = ref
        .read(shortFormCommentVisibilityProvider(widget.newsId))
        .isShortFormCommentVisible;

    if (visibleFraction == 1.0 &&
        _betterPlayerController.isPlaying() == false &&
        _autoPlay) {
      _autoPlay = false;
      _betterPlayerController.play();
      return;
    }

    if (visibleFraction < 0.5 &&
        _betterPlayerController.isVideoInitialized() == true &&
        !isCommentVisible) {
      _autoPlay = true;

      if (_betterPlayerController.isPlaying() == true) {
        _betterPlayerController.pause();

        final currentRoutePath =
            GoRouter.of(context).routeInformationProvider.value.uri.path;
        final currentPosition =
            _betterPlayerController.videoPlayerController?.value.position;

        // 숏폼 탭이 아닌 다른 탭으로 이동한 경우 비디오를 정지만 하고 0초로 되돌리지 않음
        if (!(currentRoutePath == RoutePath.shortForm) &&
            currentPosition != null) {
          // 다시 숏폼 탭으로 돌아왔을 때 스무스한 재생을 위해 1초 전으로 이동
          _betterPlayerController.seekTo(
            currentPosition - SingleShortForm._seekBackTime,
          );
          return;
        }

        _betterPlayerController.seekTo(Duration.zero);
      }
    }
  }
}
