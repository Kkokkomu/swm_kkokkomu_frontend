import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_register_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/repository/auth_repository.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/user_shortform_setting_provider.dart';
import 'package:uuid/uuid.dart';

final userInfoProvider =
    StateNotifierProvider<UserInfoStateNotifier, UserModelBase?>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);
    final userRepository = ref.watch(userRepositoryProvider);
    final authRepository = ref.watch(authRepositoryProvider);

    return UserInfoStateNotifier(
      ref: ref,
      storage: storage,
      userRepository: userRepository,
      authRepository: authRepository,
    );
  },
);

class UserInfoStateNotifier extends StateNotifier<UserModelBase?> {
  final Ref ref;
  final FlutterSecureStorage storage;
  final UserRepository userRepository;
  final AuthRepository authRepository;

  UserInfoStateNotifier({
    required this.ref,
    required this.storage,
    required this.userRepository,
    required this.authRepository,
  }) : super(UserModelLoading()) {
    getInfo();
  }

  Future<void> getInfo() async {
    final accessToken =
        await storage.read(key: SecureStorageKeys.accessTokenKey);
    final refreshToken =
        await storage.read(key: SecureStorageKeys.refreshTokenKey);

    // 인증 토큰이 없는 경우 (로그인이 불가능한 경우)
    if (refreshToken == null || accessToken == null) {
      final guestUserId =
          await storage.read(key: SecureStorageKeys.guestUserIdKey);

      // 게스트로 로그인했던 정보가 있는 경우 게스트 유저로 로그인
      if (guestUserId != null) {
        state = GuestUserModel(guestUserId: guestUserId);
        return;
      }

      // 게스트로 로그인했던 정보도 없는 경우
      state = null;
      return;
    }

    // 인증 토큰이 있는 경우
    // 토큰을 이용해 유저 정보를 가져옴
    await _fetchUserInfoWithToken();
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
    await storage.write(
        key: SecureStorageKeys.accessTokenKey, value: accessToken);
    await storage.write(
        key: SecureStorageKeys.refreshTokenKey, value: refreshToken);

    // 발급받은 토큰으로 유저 정보를 가져옴
    await _fetchUserInfoWithToken();
  }

  Future<void> guestLogin() async {
    state = UserModelLoading();

    final guestUserId = const Uuid().v4();
    await storage.write(
        key: SecureStorageKeys.guestUserIdKey, value: guestUserId);
    state = GuestUserModel(guestUserId: guestUserId);
  }

  Future<void> register({
    required String nickname,
    required String sex,
    required String birthday,
    String? recommendCode,
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
        recommendCode: recommendCode,
      ),
    );

    final accessToken = resp.data?.accessToken;
    final refreshToken = resp.data?.refreshToken;

    // 등록에 실패한 경우
    if (resp.success != true || accessToken == null || refreshToken == null) {
      state = UserModelError(message: '등록에 실패했습니다.');
      return;
    }

    // 등록에 성공한 경우 토큰 2개를 받아옴
    // 받아온 토큰들을 저장
    await storage.write(
        key: SecureStorageKeys.accessTokenKey, value: accessToken);
    await storage.write(
        key: SecureStorageKeys.refreshTokenKey, value: refreshToken);

    // 등록에 성공한 경우 받아온 토큰으로 유저 정보를 가져옴
    await _fetchUserInfoWithToken();
  }

  Future<void> logout({
    bool isAuthErrorLogout = false,
  }) async {
    if (!isAuthErrorLogout) {
      await authRepository.logout();
    }

    await Future.wait(
      [
        storage.delete(key: SecureStorageKeys.refreshTokenKey),
        storage.delete(key: SecureStorageKeys.accessTokenKey),
      ],
    );

    state = null;
  }

  Future<void> _fetchUserInfoWithToken() async {
    // 토큰을 이용해 유저 정보를 가져옴
    final userInfoResponse = await userRepository.getUserInfo();
    final userInfo = userInfoResponse.data;

    // 유저 정보를 가져오는데 실패한 경우
    if (userInfoResponse.success != true || userInfo == null) {
      state = UserModelError(message: '유저 정보를 가져오는데 실패했습니다.');
      return;
    }

    // 유저 정보를 가져오는데 성공한 경우
    // 유저 숏폼 설정을 가져오고 유저 정보를 갱신
    await ref.read(userShortFormSettingProvider.notifier).getSetting();
    state = userInfo;
  }
}
