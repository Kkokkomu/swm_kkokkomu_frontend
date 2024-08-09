import 'package:better_player/better_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

class Constants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
}

class SecureStorageKeys {
  static const String guestUserIdKey = 'guest_user_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}

class SharedPreferencesKeys {
  static const String isFirstRun = 'is_first_run';
  static const String shortFormSortType = 'short_form_sort_type';
}

class Assets {
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
