import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/model/provider_response_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_register_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/repository/auth_repository.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';
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
  }) : super(UserModelLoading());

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
      CustomToastMessage.showLoginError('로그인에 실패했어요');
      state = prevState;
      debugPrint('${socialLoginType.name} 서버로부터 인증 실패');
      return;
    }

    // 자체 서버로부터 토큰을 받아온 경우 소셜 서버의 토큰은 더 이상 필요하지 않으므로 로그아웃 처리
    if (socialLoginType == SocialLoginType.google) {
      // 구글 로그인인 경우 구글 로그아웃
      GoogleSignIn().signOut();
    }

    if (Constants.flavor == Constants.prod &&
        kReleaseMode &&
        socialLoginType == SocialLoginType.kakao) {
      // 카카오 로그인인 경우 카카오 로그아웃
      UserApi.instance.logout();
    }

    final accessToken = resp.data?.accessToken;
    final refreshToken = resp.data?.refreshToken;

    if (resp.success != true || accessToken == null) {
      // 자체 서버에서 인증 실패한 경우
      // 에러 메시지 띄움
      // 로그인에 실패했으므로 상태를 기존 상태로 원복

      if (resp.error?.code == CustomErrorCode.emailAlreadyExistsCode) {
        // 이미 해당 이메일로 가입된 다른 소셜 계정이 있는 경우는 에러 토스트 메시지를 띄우지 않고 다이얼로그를 띄움
        showInfoDialog(
          context: ref
              .read(routerProvider)
              .configuration
              .navigatorKey
              .currentContext!,
          content: '이미 해당 이메일로 가입된\n다른 소셜 계정이 있어요',
          details: '다른 소셜 계정을 사용해주세요',
        );
      } else if (resp.error?.code == CustomErrorCode.userDeletedCode) {
        // 탈퇴한 유저가 로그인 시도한 경우
        showInfoDialog(
          context: ref
              .read(routerProvider)
              .configuration
              .navigatorKey
              .currentContext!,
          content: '이미 탈퇴 처리된 계정이에요',
          details: '다른 이메일로 가입해주세요',
        );
      } else {
        // 다른 에러 코드인 경우는 에러 토스트 메시지를 띄움
        CustomToastMessage.showLoginError('로그인에 실패했어요');
      }

      state = prevState;
      debugPrint('자체 서버에서 인증 실패');

      return;
    }

    if (refreshToken == null) {
      // refreshToken이 없는 경우는 등록되지 않은 유저
      state = UnregisteredUserModel(
        socialLoginType: socialLoginType,
        accessToken: accessToken,
        agreedToTerms: false,
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

    // 로그인에 정상적으로 성공해서, 유저 정보를 가져온 경우
    // 즉, 현재 상태가 UserModel인 경우, 푸시 알림 토큰을 갱신
    if (state is UserModel) {
      await ref.read(pushNotificationServiceProvider).updateToken();
    }
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

  void agreeToTermsForRegister() {
    final prevState = state;

    if (prevState is! UnregisteredUserModel) {
      // 약관 동의를 시도하는데 UnregisteredUserModel이 아닌 경우는 로직상 에러
      // 약관 동의에 실패했으므로 에러 토스트 메시지를 띄움
      CustomToastMessage.showLoginError('회원 등록에 실패했어요');
      state = UserModelError(message: '회원 등록에 실패했어요');
      return;
    }

    state = UnregisteredUserModel(
      socialLoginType: prevState.socialLoginType,
      accessToken: prevState.accessToken,
      agreedToTerms: true,
    );
  }

  Future<ProviderResponseModel> register({
    required String nickname,
    required GenderType sex,
    required DateTime birthday,
    String? recommendCode,
  }) async {
    final prevState = state;

    if (prevState is! UnregisteredUserModel) {
      // 등록을 시도하는데 UnregisteredUserModel이 아닌 경우는 로직상 에러
      // 등록에 실패했으므로 에러 토스트 메시지를 띄움
      // 등록화면에서 로그인 화면으로 이동시켜야 하므로 상태를 에러 상태로 변경
      CustomToastMessage.showLoginError('회원 등록에 실패했어요');
      state = UserModelError(message: '회원 등록에 실패했어요');
      return ProviderResponseModel(
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '회원 등록에 실패했어요',
      );
    }

    final resp = await authRepository.register(
      authorizationHeader: 'Bearer ${prevState.accessToken}',
      requiredBody: PostRegisterBody(
        provider: prevState.socialLoginType.name.toUpperCase(),
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
      // 닉네임이 중복인 경우 UserModelError로 변경하지 않고 에러 코드와 메세지를 반환
      if (resp.error?.code == CustomErrorCode.nicknameAlreadyExistsCode) {
        return ProviderResponseModel(
          success: false,
          errorCode: CustomErrorCode.nicknameAlreadyExistsCode,
          errorMessage: resp.error?.message ?? '이미 존재하는 닉네임이에요',
        );
      }

      // 그 외 오류에 의해서 등록에 실패한 경우 에러 토스트 메시지를 띄움
      // 등록화면에서 로그인 화면으로 이동시켜야 하므로 상태를 에러 상태로 변경
      CustomToastMessage.showLoginError('회원 등록에 실패했어요');
      state = UserModelError(message: '회원 등록에 실패했어요');
      return ProviderResponseModel(
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '회원 등록에 실패했어요',
      );
    }

    // 등록에 성공한 경우 토큰 2개를 받아옴
    // 받아온 토큰들을 저장
    await storage.write(
        key: SecureStorageKeys.accessTokenKey, value: accessToken);
    await storage.write(
        key: SecureStorageKeys.refreshTokenKey, value: refreshToken);

    // 등록에 성공한 경우 받아온 토큰으로 유저 정보를 가져옴
    _fetchUserInfoWithToken(prevState).then(
      (_) {
        // 로그인에 정상적으로 성공해서, 유저 정보를 가져온 경우
        // 즉, 현재 상태가 UserModel인 경우, 푸시 알림 토큰을 갱신
        if (state is UserModel) {
          ref.read(pushNotificationServiceProvider).updateToken();
        }
      },
    );

    return ProviderResponseModel(
      success: true,
      errorCode: null,
      errorMessage: null,
    );
  }

  void cancelRegister() {
    // 등록화면에서 취소 버튼을 누른 경우
    // 등록을 취소하고 로그인 화면으로 이동시키기 위해 상태를 에러 상태로 변경
    CustomToastMessage.showLoginError('회원 등록을 취소했어요');
    state = UserModelError(message: '회원 등록을 취소했어요');
  }

  Future<void> logout({
    bool isAuthErrorLogout = false,
  }) async {
    // 강제 로그아웃이 아닌 경우
    if (!isAuthErrorLogout) {
      // 로그아웃 처리 전, 푸시 알림 토큰 삭제
      await ref.read(pushNotificationServiceProvider).deleteToken();
      // 토큰 삭제 후, 로그아웃 처리
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
      CustomToastMessage.showLoginError('세션이 만료되었어요');
      state = UserModelError(message: '세션이 만료되었어요');

      return;
    }

    // 일반적인 로그아웃의 경우 -> 게스트 유저로 상태 변경
    state = GuestUserModel(
      deviceId: await storage.read(key: SecureStorageKeys.deviceIdKey) ??
          await _createAndSaveDeviceId(),
    );
  }

  Future<bool> deleteAccount() async {
    final resp = await userRepository.deleteAccount();

    if (resp.success != true) {
      return false;
    }

    await Future.wait(
      [
        storage.delete(key: SecureStorageKeys.refreshTokenKey),
        storage.delete(key: SecureStorageKeys.accessTokenKey),
      ],
    );

    return true;
  }

  void setUserModelToInitial() => state = InitialUserModel();

  bool updateUserInfo(DetailUserModel detailUserInfo) {
    // 상태가 UserModel이 아닌 경우는 로직상 에러 (잘못된 상태에서 호출한 경우)
    if (state is! UserModel) {
      return false;
    }

    final prevState = state as UserModel;

    // 이전 상태와 변경할 유저 정보가 같은 경우는 변경할 필요가 없음
    if (prevState.nickname == detailUserInfo.nickname &&
        prevState.email == detailUserInfo.email &&
        prevState.profileImg == detailUserInfo.profileUrl) {
      return true;
    }

    state = prevState.copyWith(
      nickname: detailUserInfo.nickname,
      email: detailUserInfo.email,
      profileImg: detailUserInfo.profileUrl,
    );

    return true;
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
        CustomToastMessage.showLoginError('유저 정보를 가져오는데 실패했어요');
      }

      // 이전 상태가 UserModelLoading인 경우는 스플래시 스크린에서 자동 로그인에 실패한 경우이므로
      // 스플래시 스크린에서 로그인 화면으로 이동시키기 위해 UserModelError로 상태 변경
      if (prevState is UserModelLoading) {
        state = UserModelError(message: '유저 정보를 가져오는데 실패했어요');
        return;
      }

      // 이전 상태가 UnregisteredUserModel인 경우는 등록화면에서 로그인에 실패한 경우이므로
      // 등록화면에서 로그인 화면으로 이동시키기 위해 UserModelError로 상태 변경
      if (prevState is UnregisteredUserModel) {
        state = UserModelError(message: '유저 정보를 가져오는데 실패했어요');
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
    // 로그아웃 후 재로그인 시 이전 세팅이 남아있는 문제를 해결하기 위해 invalidate 호출 후, getSetting 호출
    // 홈(숏폼) 화면에서 비로그인 상태에서 로그인 상태로 전환할 때, 바텀 네비게이션바 상태를 초기화 하기 위해 invalidate 호출
    // 즉, 댓글창 열어둔 상태에서 로그인했을 때, 바텀 네비게이션바가 비활성화된 상태로 남아있는 문제를 해결하기 위해 invalidate 호출
    ref.invalidate(loggedInUserShortFormSettingProvider);
    ref.invalidate(bottomNavigationBarStateProvider);
    await ref.read(loggedInUserShortFormSettingProvider.notifier).getSetting();
    state = userInfo;
  }

  // 디바이스 ID를 생성하고 저장
  Future<String> _createAndSaveDeviceId() async {
    final deviceId = const Uuid().v4();
    await storage.write(key: SecureStorageKeys.deviceIdKey, value: deviceId);

    return deviceId;
  }
}
