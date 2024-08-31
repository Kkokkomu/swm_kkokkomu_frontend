import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/custom_better_player_controller_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/short_form_play_pause_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

final customBetterPlayerControllerProvider = StateNotifierProvider.autoDispose
    .family<
        CustomBetterPlayerControllerStateNotifier,
        CustomBetterPlayerControllerModelBase,
        ({int newsId, String shortFormUrl})>(
  (ref, shortFormInfo) => CustomBetterPlayerControllerStateNotifier(
    ref: ref,
    shortFormInfo: shortFormInfo,
  ),
);

class CustomBetterPlayerControllerStateNotifier
    extends StateNotifier<CustomBetterPlayerControllerModelBase> {
  final Duration _seekBackTime = const Duration(seconds: 1);
  final Ref ref;
  final ({int newsId, String shortFormUrl}) shortFormInfo;
  BetterPlayerController? _betterPlayerController;
  bool _autoPlay = true;

  CustomBetterPlayerControllerStateNotifier({
    required this.ref,
    required this.shortFormInfo,
  }) : super(CustomBetterPlayerControllerModelLoading()) {
    setUpVideo();
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose(forceDispose: true);
    super.dispose();
  }

  void setUpVideo() async {
    state = CustomBetterPlayerControllerModelLoading();

    _betterPlayerController?.dispose(forceDispose: true);

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        playerVisibilityChangedBehavior: _onVisibilityChanged,
        fit: BoxFit.fitHeight,
        aspectRatio: 1 / 10,
        looping: true,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: false,
        ),
      ),
    );

    try {
      await _betterPlayerController!.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          shortFormInfo.shortFormUrl,
          cacheConfiguration: customBetterPlayerCacheConfiguration,
          bufferingConfiguration: customBetterPlayerBufferingConfiguration,
        ),
      );

      state = CustomBetterPlayerControllerModel(_betterPlayerController!);
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('에러 비디오: ${shortFormInfo.shortFormUrl}');
      _betterPlayerController?.dispose(forceDispose: true);

      state = CustomBetterPlayerControllerModelError('비디오를 불러오는 중 오류가 발생했습니다.');
    }
  }

  void togglePausePlay() {
    if (_betterPlayerController?.isVideoInitialized() != true) {
      return;
    }

    if (_betterPlayerController?.isPlaying() == true) {
      _betterPlayerController?.pause();
      ref
          .read(
            shortFormPlayPauseButtonVisibilityProvider(shortFormInfo.newsId)
                .notifier,
          )
          .state = (isButtonVisible: true, isPlaying: false);
      return;
    }

    if (_betterPlayerController?.isPlaying() == false) {
      _betterPlayerController?.play();
      ref
          .read(
            shortFormPlayPauseButtonVisibilityProvider(shortFormInfo.newsId)
                .notifier,
          )
          .state = (isButtonVisible: true, isPlaying: true);
      return;
    }
  }

  void _onVisibilityChanged(double visibleFraction) {
    final isCommentVisible = ref
        .read(shortFormCommentHeightControllerProvider(shortFormInfo.newsId))
        .isShortFormCommentVisible;

    // 비디오가 화면에 완전히 보이는 경우 자동 재생
    if (visibleFraction == 1.0 &&
        _betterPlayerController?.isPlaying() == false &&
        _autoPlay) {
      _autoPlay = false;
      _betterPlayerController?.play();
      return;
    }

    // 화면이 절반 이상 가려진 경우 비디오를 정지
    // 댓글이 화면을 가리는 경우에는 비디오를 정지하지 않음
    if (visibleFraction < 0.5 &&
        _betterPlayerController?.isVideoInitialized() == true &&
        !isCommentVisible) {
      // 다음에 화면에 보일 때 자동 재생을 위해 플래그 설정
      _autoPlay = true;

      // 비디오 정지
      if (_betterPlayerController?.isPlaying() == true) {
        _betterPlayerController?.pause();
      }

      // 현재 라우트 path
      final currentRoutePath =
          ref.read(routerProvider).routeInformationProvider.value.uri.path;
      // 현재 비디오의 재생 위치
      final currentPosition =
          _betterPlayerController?.videoPlayerController?.value.position;

      // 숏폼 탭이 아닌 다른 탭으로 이동한 경우 비디오를 정지만 하고 0초로 되돌리지 않음
      if (!(currentRoutePath.startsWith(RoutePath.shortForm)) &&
          currentPosition != null) {
        // 다시 숏폼 탭으로 돌아왔을 때 스무스한 재생을 위해 1초 전으로 이동
        _betterPlayerController?.seekTo(
          currentPosition - _seekBackTime,
        );
        return;
      }

      // 숏폼 탭에서 다른 숏폼으로 넘어간 경우 비디오를 정지하고 0초로 되돌림
      _betterPlayerController?.seekTo(Duration.zero);
    }
  }
}
