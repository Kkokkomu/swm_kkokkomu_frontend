import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_login_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/repository/auth_repository.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_info_repository.dart';
import 'package:uuid/uuid.dart';

final userInfoProvider =
    StateNotifierProvider<UserInfoStateNotifier, UserModelBase?>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);
    final userInfoRepository = ref.watch(userInfoRepositoryProvider);
    final authRepository = ref.watch(authRepositoryProvider);

    return UserInfoStateNotifier(
      storage: storage,
      userInfoRepository: userInfoRepository,
      authRepository: authRepository,
    );
  },
);

class UserInfoStateNotifier extends StateNotifier<UserModelBase?> {
  final FlutterSecureStorage storage;
  final UserInfoRepository userInfoRepository;
  final AuthRepository authRepository;

  UserInfoStateNotifier({
    required this.storage,
    required this.userInfoRepository,
    required this.authRepository,
  }) : super(UserModelLoading()) {
    getInfo();
  }

  Future<void> getInfo() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // 인증 토큰이 없는 경우 (로그인이 불가능한 경우)
    if (refreshToken == null || accessToken == null) {
      final deviceID = await storage.read(key: DEVICE_ID);

      // 디바이스 아이디가 있는 경우 게스트 유저로 로그인
      if (deviceID != null) {
        state = GuestUserModel(id: deviceID);
        return;
      }

      // 디바이스 아이디도 없는 경우
      state = null;
      return;
    }

    // TODO : 토큰이 있는 경우 서버로부터 유저 정보를 받아옴
    state = null;
  }

  Future<UserModelBase> login(SocialLoginType socialLoginType) async {
    state = UserModelLoading();

    final resp = await authRepository.login(socialLoginType);

    if (resp == null) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }

    print(resp);

    // TODO: 로그인 성공 시 카카오 엑세스 토큰을 자체 서버에 전송 후 유저 정보를 받아옴
    state = UserModelError(message: '로그인에 실패했습니다.');
    return Future.value(state);
  }

  Future<UserModelBase> guestLogin() async {
    state = UserModelLoading();

    final deviceID = const Uuid().v4();
    await storage.write(key: DEVICE_ID, value: deviceID);
    state = GuestUserModel(id: deviceID);

    return Future.value(state);
  }
}
