import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_register_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/repository/auth_repository.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/user_shortform_setting_provider.dart';
import 'package:uuid/uuid.dart';

final userInfoProvider =
    StateNotifierProvider<UserInfoStateNotifier, UserModelBase>(
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

class UserInfoStateNotifier extends StateNotifier<UserModelBase> {
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
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final prevState = state;

    final accessToken =
        await storage.read(key: SecureStorageKeys.accessTokenKey);
    final refreshToken =
        await storage.read(key: SecureStorageKeys.refreshTokenKey);

    // 인증 토큰이 없는 경우 (로그인이 불가능한 경우)
    if (refreshToken == null || accessToken == null) {
      // 디바이스 ID를 가져옴
      final deviceId = await storage.read(key: SecureStorageKeys.deviceIdKey);

      // 디바이스 정보가 있는 경우 (한번이라도 로그인 했었던 경우)
      // 게스트 유저로 로그인
      if (deviceId != null) {
        state = GuestUserModel(deviceId: deviceId);
        return;
      }

      // 디바이스 정보도 없는 경우
      // 앱을 설치하고 한번도 메인화면으로 가보지 않은 경우
      state = InitialUserModel();
      return;
    }

    // 인증 토큰이 있는 경우
    // 토큰을 이용해 유저 정보를 가져옴
    await _fetchUserInfoWithToken(prevState);
  }

  Future<void> login(SocialLoginType socialLoginType) async {
    final prevState = state;
    state = UserModelLoading();

    final resp = await authRepository.login(socialLoginType);

    if (resp == null) {
      // resp가 null인 경우는 소셜로그인을 제공해주는 서버에서 인증 실패한 경우 ex) 카카오, 애플 서버에서 인증 실패
      // 에러 토스트 메시지 띄움
      // 로그인에 실패했으므로 상태를 기존 상태로 원복
      CustomToastMessage.showLoginError('로그인에 실패했습니다.');
      state = prevState;
      debugPrint('${socialLoginType.name} 서버로부터 인증 실패');
      return;
    }

    final accessToken = resp.data?.accessToken;
    final refreshToken = resp.data?.refreshToken;

    if (resp.success != true || accessToken == null) {
      // 자체 서버에서 인증 실패한 경우
      // 에러 토스트 메시지 띄움
      // 로그인에 실패했으므로 상태를 기존 상태로 원복
      CustomToastMessage.showLoginError('로그인에 실패했습니다.');
      state = prevState;
      debugPrint('자체 서버에서 인증 실패');
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
    await _fetchUserInfoWithToken(prevState);
  }

  Future<void> guestLogin() async {
    state = UserModelLoading();

    // 디바이스 ID를 가져옴
    final deviceId = await storage.read(key: SecureStorageKeys.deviceIdKey);
    // 디바이스 ID가 없는 경우 ID를 새로 생성하고 저장한 후, 게스트 유저로 로그인
    state = GuestUserModel(
      deviceId: deviceId ?? await _createAndSaveDeviceId(),
    );
  }

  Future<void> register({
    required String nickname,
    required String sex,
    required String birthday,
    String? recommendCode,
  }) async {
    final prevState = state;

    if (state is! UnregisteredUserModel) {
      // 등록에 실패했으므로 에러 토스트 메시지를 띄움
      // 등록화면에서 로그인 화면으로 이동시켜야 하므로 상태를 에러 상태로 변경
      CustomToastMessage.showLoginError('등록에 실패했습니다.');
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
      // 등록에 실패했으므로 에러 토스트 메시지를 띄움
      // 등록화면에서 로그인 화면으로 이동시켜야 하므로 상태를 에러 상태로 변경
      CustomToastMessage.showLoginError('등록에 실패했습니다.');
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
    await _fetchUserInfoWithToken(prevState);
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

    // 세션이 만료되어 강제 로그아웃되는 경우
    // 에러 토스트 메시지를 띄움
    // 자동로그인이 해제되었음을 알리기 위해 UserModelError로 상태 변경하여 최초 로그인 화면으로 이동시킴
    if (isAuthErrorLogout) {
      CustomToastMessage.showLoginError('세션이 만료되었습니다.');
      state = UserModelError(message: '세션이 만료되었습니다.');

      return;
    }

    // 일반적인 로그아웃의 경우 -> 게스트 유저로 상태 변경
    state = GuestUserModel(
      deviceId: await storage.read(key: SecureStorageKeys.deviceIdKey) ??
          await _createAndSaveDeviceId(),
    );
  }

  Future<void> _fetchUserInfoWithToken(UserModelBase prevState) async {
    // 토큰을 이용해 유저 정보를 가져옴
    final userInfoResponse = await userRepository.getUserInfo();
    final userInfo = userInfoResponse.data;

    // 유저 정보를 가져오는데 실패한 경우
    if (userInfoResponse.success != true || userInfo == null) {
      // 에러 코드가 401인 경우 세션만료로 강제 로그아웃된 경우
      // 이 경우 토큰 만료 에러 토스트 메세지가 별도로 뜨므로 여기서는 띄우지 않음
      // 에러 코드가 401이 아닌 경우만 에러 토스트 메세지 띄움
      if (userInfoResponse.error?.code != '401') {
        CustomToastMessage.showLoginError('유저 정보를 가져오는데 실패했습니다.');
      }

      // 이전 상태가 UserModelLoading인 경우는 스플래시 스크린에서 자동 로그인에 실패한 경우이므로
      // 스플래시 스크린에서 로그인 화면으로 이동시키기 위해 UserModelError로 상태 변경
      if (prevState is UserModelLoading) {
        state = UserModelError(message: '유저 정보를 가져오는데 실패했습니다.');
        return;
      }

      // 이전 상태가 UnregisteredUserModel인 경우는 등록화면에서 로그인에 실패한 경우이므로
      // 등록화면에서 로그인 화면으로 이동시키기 위해 UserModelError로 상태 변경
      if (prevState is UnregisteredUserModel) {
        state = UserModelError(message: '유저 정보를 가져오는데 실패했습니다.');
        return;
      }

      // 그 외의 경우는 상태를 기존 상태로 원복
      state = prevState;
      return;
    }

    // 최초로 로그인에 성공한 경우 (디바이스 ID값이 없는 경우)
    // 디바이스 ID 생성하고 저장
    final deviceId = await storage.read(key: SecureStorageKeys.deviceIdKey);
    if (deviceId == null) {
      await _createAndSaveDeviceId();
    }

    // 유저 정보를 가져오는데 성공한 경우
    // 유저 숏폼 설정을 가져오고 유저 정보를 갱신
    await ref.read(userShortFormSettingProvider.notifier).getSetting();
    state = userInfo;
  }

  // 디바이스 ID를 생성하고 저장
  Future<String> _createAndSaveDeviceId() async {
    final deviceId = const Uuid().v4();
    await storage.write(key: SecureStorageKeys.deviceIdKey, value: deviceId);

    return deviceId;
  }
}
