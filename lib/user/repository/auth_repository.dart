import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/token_response_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_register_body.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return AuthRepository(
      dio,
      baseUrl: '${Constants.baseUrl}/oauth2',
    );
  },
);

@RestApi()
abstract class _AuthServiceApi {
  // http://$serverHost/oauth2

  @POST('/login/{socialLoginType}')
  // ignore: unused_element
  Future<ResponseModel<TokenResponseModel?>> _socialLogin({
    @Header("Authorization") required String authorizationHeader,
    @Path("socialLoginType") required SocialLoginType socialLoginType,
  });

  @POST('/register')
  Future<ResponseModel<TokenResponseModel?>> register({
    @Header("Authorization") required String authorizationHeader,
    @Body() required PostRegisterBody requiredBody,
  });

  @POST('/logout')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> logout();
}

class AuthRepository extends __AuthServiceApi {
  AuthRepository(
    super._dio, {
    super.baseUrl,
  });

  Future<ResponseModel<TokenResponseModel?>?> login(
    SocialLoginType socialLoginType,
  ) async {
    String? authorizationHeader;

    switch (socialLoginType) {
      case SocialLoginType.apple:
        authorizationHeader = await _getAppleIdentityToken();
        break;

      case SocialLoginType.google:
        authorizationHeader = await _getGoogleAccessToken();
        break;

      case SocialLoginType.kakao:
        authorizationHeader = await _getKakaoAccessToken();
        break;
    }

    if (authorizationHeader == null) {
      return null;
    }

    return await super._socialLogin(
      authorizationHeader: "Bearer $authorizationHeader",
      socialLoginType: socialLoginType,
    );
  }

  Future<String?> _getAppleIdentityToken() async {
    String? appleIdentityToken;

    try {
      appleIdentityToken = (await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
      ))
          .identityToken;

      debugPrint('애플 로그인 성공');
    } catch (e) {
      debugPrint('애플 로그인 실패');
      debugPrint(e.toString());
    }

    return appleIdentityToken;
  }

  Future<String?> _getGoogleAccessToken() async {
    String? googleAccessToken;
    try {
      googleAccessToken =
          (await (await GoogleSignIn().signIn())?.authentication)?.accessToken;
    } catch (e) {
      debugPrint(e.toString());
    }

    if (googleAccessToken != null) {
      debugPrint('구글 로그인 성공');
    } else {
      debugPrint('구글 로그인 실패');
    }

    return googleAccessToken;
  }

  Future<String?> _getKakaoAccessToken() async {
    String? kakaoAccessToken;
    try {
      // 카카오톡 실행 가능 여부 확인
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      if (await isKakaoTalkInstalled()) {
        try {
          kakaoAccessToken =
              (await UserApi.instance.loginWithKakaoTalk()).accessToken;
          debugPrint('카카오톡으로 로그인 성공');
        } catch (error) {
          debugPrint('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            kakaoAccessToken =
                (await UserApi.instance.loginWithKakaoAccount()).accessToken;
            debugPrint('카카오계정으로 로그인 성공');
          } catch (error) {
            debugPrint('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          kakaoAccessToken =
              (await UserApi.instance.loginWithKakaoAccount()).accessToken;
          debugPrint('카카오계정으로 로그인 성공');
        } catch (error) {
          debugPrint('카카오계정으로 로그인 실패 $error');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return kakaoAccessToken;
  }
}
