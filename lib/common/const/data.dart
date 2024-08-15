import 'package:better_player/better_player.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

typedef PaginationWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T model,
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

  static const Duration shortFormCommentAnimationDuration =
      Duration(milliseconds: 200);
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

class Assets {
  static const String env = 'assets/config/.env';
  static const String splashIcon = 'assets/images/splash_icon.png';
  static const String appleLoginButtonImage = 'assets/images/apple_login.png';
  static const String kakaoLoginButtonImage =
      'assets/images/kakao_login_large_wide.png';
}

enum SocialLoginType { apple, kakao }

@JsonEnum(alwaysCreate: true, valueField: 'name')
enum ShortFormSortType {
  recommend('RECOMMEND'),
  latest('LATEST');

  final String name;

  const ShortFormSortType(this.name);

  static final _shortFormSortTypeNameMap =
      _$ShortFormSortTypeEnumMap.map((key, value) => MapEntry(value, key));

  static ShortFormSortType? fromName(String name) =>
      _shortFormSortTypeNameMap[name];
}

enum NewsCategory {
  politics,
  economy,
  social,
  entertain,
  sports,
  living,
  world,
  it
}

enum ShortFormCommentSortType { popular, latest }

enum RootTabBottomNavigationBarType {
  exploration(RoutePath.exploration),
  shortForm(RoutePath.shortForm),
  myPage(RoutePath.myPage);

  final String path;

  const RootTabBottomNavigationBarType(this.path);
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
class CustomPhysics extends ScrollPhysics {
  const CustomPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 20,
        stiffness: 100,
        damping: 3,
      );
}
