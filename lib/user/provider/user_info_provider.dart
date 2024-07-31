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
    String? deviceID = await storage.read(key: DEVICE_ID);

    if (deviceID == null) {
      const uuid = Uuid();
      deviceID = uuid.v4();
      await storage.write(key: DEVICE_ID, value: deviceID);
    }

    try {
      final resp =
          await userInfoRepository.getInfo(body: PostLoginBody(uuid: deviceID));

      if (resp.success != null && resp.success!) {
        state = UserModel(id: deviceID);
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      state = UserModelError(message: '로그인에 실패했습니다.');
    }
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
    return Future.value(state);
  }
}
