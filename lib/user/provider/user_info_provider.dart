import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_register_body.dart';
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

    // TODO: 토큰을 이용해 유저 모델을 가져오는 API 호출
    state = UserModel();
  }

  Future<void> login(SocialLoginType socialLoginType) async {
    state = UserModelLoading();

    final resp = await authRepository.login(socialLoginType);

    if (resp == null) {
      // resp가 null인 경우는 소셜로그인을 제공해주는 서버에서 인증 실패한 경우 ex) 카카오, 애플 서버에서 인증 실패
      state = UserModelError(message: '로그인에 실패했습니다.');
      print('${socialLoginType.name} 서버로부터 인증 실패');
      return;
    }

    final accessToken = resp.data?.accessToken;
    final refreshToken = resp.data?.refreshToken;

    if (resp.success != true || accessToken == null) {
      // 자체 서버에서 인증 실패한 경우
      state = UserModelError(message: '로그인에 실패했습니다.');
      print('자체 서버에서 인증 실패');
      return;
    }

    if (refreshToken == null) {
      // refreshToken이 없는 경우는 등록되지 않은 유저
      state = UnregisteredUserModel(
        socialLoginType: socialLoginType,
        accessToken: accessToken,
      );
      return;
    }

    // accessToken, refreshToken 둘 다 있는 경우는 등록된 유저
    // accessToken, refreshToken 저장
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

    // TODO: 토큰을 이용해 유저 모델을 가져오는 API 호출
    state = UserModel();
    return;
  }

  Future<void> guestLogin() async {
    state = UserModelLoading();

    final deviceID = const Uuid().v4();
    await storage.write(key: DEVICE_ID, value: deviceID);
    state = GuestUserModel(id: deviceID);
  }

  Future<void> register({
    required String nickname,
    required String sex,
    required String birthday,
    String? recommandCode,
  }) async {
    if (state is! UnregisteredUserModel) {
      state = UserModelError(message: '등록에 실패했습니다.');
      return;
    }

    final unRegisteredUserState = state as UnregisteredUserModel;

    final resp = await authRepository.register(
      authorizationHeader: 'Bearer ${unRegisteredUserState.accessToken}',
      requiredBody: PostRegisterBody(
        provider: unRegisteredUserState.socialLoginType.name.toUpperCase(),
        nickname: nickname,
        sex: sex,
        birthday: birthday,
        recommandCode: recommandCode,
      ),
    );

    final accessToken = resp.data?.accessToken;
    final refreshToken = resp.data?.refreshToken;

    if (resp.success != true || accessToken == null || refreshToken == null) {
      state = UserModelError(message: '등록에 실패했습니다.');
      return;
    }

    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

    // TODO: 토큰을 이용해 유저 모델을 가져오는 API 호출
    state = UserModel();
  }
}
