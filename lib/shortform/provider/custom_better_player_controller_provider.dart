import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/custom_better_player_controller_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/short_form_play_pause_button_visibility_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_logging_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final customBetterPlayerControllerProvider =
    StateNotifierProvider.autoDispose.family<
        CustomBetterPlayerControllerStateNotifier,
        CustomBetterPlayerControllerModelBase,
        ({
          ShortFormScreenType shortFormScreenType,
          int newsId,
          String shortFormUrl,
        })>(
  (ref, shortFormInfo) => CustomBetterPlayerControllerStateNotifier(
    ref: ref,
    shortFormInfo: shortFormInfo,
  ),
);

class CustomBetterPlayerControllerStateNotifier
    extends StateNotifier<CustomBetterPlayerControllerModelBase> {
  final Duration _seekBackTime = const Duration(seconds: 1);
  final Ref ref;
  final ({
    ShortFormScreenType shortFormScreenType,
    int newsId,
    String shortFormUrl,
  }) shortFormInfo;
  BetterPlayerController? _betterPlayerController;
  bool _autoPlay = true;
  bool isViewCntTriggered = false;

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
        playerVisibilityChangedBehavior: (visibilityFraction) =>
            _onVisibilityChanged(
          visibilityFraction,
          shortFormInfo.shortFormScreenType,
        ),
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
            shortFormPlayPauseButtonVisibilityProvider((
              shortFormScreenType: shortFormInfo.shortFormScreenType,
              newsId: shortFormInfo.newsId,
            )).notifier,
          )
          .state = (isButtonVisible: true, isPlaying: false);
      return;
    }

    if (_betterPlayerController?.isPlaying() == false) {
      _betterPlayerController?.play();
      ref
          .read(
            shortFormPlayPauseButtonVisibilityProvider((
              shortFormScreenType: shortFormInfo.shortFormScreenType,
              newsId: shortFormInfo.newsId,
            )).notifier,
          )
          .state = (isButtonVisible: true, isPlaying: true);
      return;
    }
  }

  void _onVisibilityChanged(
      double visibleFraction, ShortFormScreenType shortFormScreenType) {
    final isCommentVisible = ref
        .read(shortFormCommentHeightControllerProvider(shortFormInfo.newsId))
        .isShortFormCommentVisible;

    // 비디오가 화면에 완전히 보이는 경우 자동 재생
    if (visibleFraction == 1.0 && _autoPlay) {
      _autoPlay = false;
      _betterPlayerController?.play();

      // 조회수 증가 트리거
      if (!isViewCntTriggered) {
        isViewCntTriggered = true;
        _triggerViewCnt();
      }
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

      // 보고 있던 숏폼 탭을 벗어나 다른 탭으로 이동한 경우 0초로 되돌리지 않음
      if (currentRoutePath != shortFormScreenType.path &&
          currentPosition != null) {
        // 다시 숏폼 탭으로 돌아왔을 때 스무스한 재생을 위해 1초 전으로 이동
        _betterPlayerController?.seekTo(
          currentPosition - _seekBackTime,
        );
        return;
      }

      // 다른 숏폼으로 넘어간 경우 비디오를 정지하고 0초로 되돌림
      _betterPlayerController?.seekTo(Duration.zero);
      // 다시 재생할 때 조회수 증가 트리거를 위해 플래그 초기화
      isViewCntTriggered = false;
    }
  }

  // 조회수 증가 트리거
  void _triggerViewCnt() {
    final userInfo = ref.read(userInfoProvider);

    // 로그인 상태에 따라 다른 API 호출
    if (userInfo is UserModel) {
      // 로그인 유저 API 호출
      ref.read(shortFormLoggingRepositoryProvider).logViewCntByLoggedInUser(
            body: PostNewsIdBody(newsId: shortFormInfo.newsId),
          );
    } else {
      // 비로그인 유저 API 호출
      ref.read(shortFormLoggingRepositoryProvider).logViewCntByGuestUser(
            body: PostNewsIdBody(newsId: shortFormInfo.newsId),
          );
    }
  }
}
