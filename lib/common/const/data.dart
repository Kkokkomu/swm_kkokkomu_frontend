import 'package:better_player/better_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const DEVICE_ID = 'DEVICE_ID';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final ip = dotenv.env['BASE_URL'] ?? '';

enum SocialLoginType { APPLE, KAKAO }

const customBetterPlayerCacheConfiguration = BetterPlayerCacheConfiguration(
  useCache: true,
  maxCacheSize: 500 * 1024 * 1024,
  maxCacheFileSize: 100 * 1024 * 1024,
);

const customBetterPlayerBufferingConfiguration =
    BetterPlayerBufferingConfiguration(
  minBufferMs: 5000,
  maxBufferMs: 10000,
  bufferForPlaybackMs: 2500,
  bufferForPlaybackAfterRebufferMs: 5000,
);
