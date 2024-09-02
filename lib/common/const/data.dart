import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef PaginationWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T model,
);

typedef PaginationSeparatorBuilder = Widget Function(
  BuildContext context,
  int index,
);

class Constants {
  // dotenv.env 로 불러오는 값들은 반드시 env 파일일 로드된 후에 사용해야 함
  static final String? kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String? defaultProfileImageUrl =
      dotenv.env['DEFAULT_PROFILE_IMAGE_URL'];

  // BottomNavigationBar 높이
  static const double bottomNavigationBarHeight = 60.0;
  // SafeArea 를 고려한 BottomNavigationBar 높이
  // 반드시 main.dart 에서 SafeArea 높이를 사용하여 수정 후 사용해야함
  static double bottomNavigationBarHeightWithSafeArea =
      bottomNavigationBarHeight;

  static const Color modalBarrierColor = Colors.black54;

  static const int cursorPaginationFetchCount = 20;
  static const int offsetPaginationFetchCount = 10;

  // 서버로 부터 Id 값을 받지 못했을 때 사용하는 에러 Id
  static const int unknownErrorId = -99999;
}

class AnimationDuration {
  // 숏폼 댓글 애니메이션 시간
  static const Duration shortFormCommentAnimationDuration =
      Duration(milliseconds: 300);

  // 숏폼 재생/정지 버튼 애니메이션 시간
  static const Duration startPauseButtonScaleAnimationDuration =
      Duration(milliseconds: 300);
  // 숏폼 재생/정지 버튼 홀드 시간
  static const Duration startPauseButtonHoldDuration =
      Duration(milliseconds: 500);
  // 숏폼 재생/정지 버튼 전체 시간
  // 홀드 시간 + 애니메이션 시간 * 2
  static const Duration startPauseButtonTotalDuration =
      Duration(milliseconds: 1100);
}

class SecureStorageKeys {
  static const String deviceIdKey = 'device_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}

class SharedPreferencesKeys {
  static const String isFirstRun = 'is_first_run';
  static const String shortFormSortType = 'short_form_sort_type';
}

class RoutePath {
  static const String exploration = '/exploration';
  static const String shortForm = '/shortform';
  static const String myPage = '/mypage';
}

// BetterPlayer 캐시 설정값
const customBetterPlayerCacheConfiguration = BetterPlayerCacheConfiguration(
  useCache: true,
  maxCacheSize: 500 * 1024 * 1024,
  maxCacheFileSize: 100 * 1024 * 1024,
);

// BetterPlayer 버퍼링 설정값
const customBetterPlayerBufferingConfiguration =
    BetterPlayerBufferingConfiguration(
  minBufferMs: 5000,
  maxBufferMs: 10000,
  bufferForPlaybackMs: 2500,
  bufferForPlaybackAfterRebufferMs: 5000,
);

// 스크롤 물리 효과 설정
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 20,
        stiffness: 100,
        damping: 3,
      );
}
