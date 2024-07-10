import 'package:better_player/better_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const DEVICE_ID = 'DEVICE_ID';

final ip = dotenv.env['BASE_URL'] ?? '';

const customBetterPlayerCacheConfiguration = BetterPlayerCacheConfiguration(
  useCache: true,
  maxCacheSize: 300 * 1024 * 1024,
  maxCacheFileSize: 100 * 1024 * 1024,
);

const customBetterPlayerBufferingConfiguration =
    BetterPlayerBufferingConfiguration(
  minBufferMs: 5000,
  maxBufferMs: 10000,
  bufferForPlaybackMs: 2500,
  bufferForPlaybackAfterRebufferMs: 5000,
);
