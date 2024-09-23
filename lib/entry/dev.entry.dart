import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import '../main.dart' as entry;

void main() async {
  // 제일 먼저 env 파일 로드
  await dotenv.load(fileName: Assets.config.aEnvDev);

  entry.main();
}
