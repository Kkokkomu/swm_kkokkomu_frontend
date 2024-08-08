import 'package:better_player/better_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
}

class SecureStorageKeys {
  static const String guestUserIdKey = 'guest_user_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}

class Assets {
  static const String splashIcon = 'assets/images/splash_icon.png';
  static const String appleLoginButtonImage = 'assets/images/apple_login.png';
  static const String kakaoLoginButtonImage =
      'assets/images/kakao_login_large_wide.png';
}

enum SocialLoginType { apple, kakao }

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
