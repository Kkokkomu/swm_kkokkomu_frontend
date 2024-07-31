import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<String?> login(
    SocialLoginType socialLoginType,
  ) async {
    switch (socialLoginType) {
      case SocialLoginType.APPLE:
        return await _appleLogin();
      case SocialLoginType.KAKAO:
        return await _kakaoLogin();
      default:
        return null;
    }
  }

  Future<String?> _appleLogin() async {
    return null;
  }

  Future<String?> _kakaoLogin() async {
    String? kakaoAccessToken;
    try {
      // 카카오톡 실행 가능 여부 확인
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      if (await isKakaoTalkInstalled()) {
        try {
          kakaoAccessToken =
              (await UserApi.instance.loginWithKakaoTalk()).accessToken;
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            kakaoAccessToken =
                (await UserApi.instance.loginWithKakaoAccount()).accessToken;
            print('카카오계정으로 로그인 성공');
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          kakaoAccessToken =
              (await UserApi.instance.loginWithKakaoAccount()).accessToken;
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } catch (e) {
      print(e);
    }
    return kakaoAccessToken;
  }
}
