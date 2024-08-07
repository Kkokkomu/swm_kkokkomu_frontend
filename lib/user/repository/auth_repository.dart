import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
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
      baseUrl: 'http://${Constants.serverHost}/oauth2',
    );
  },
);

@RestApi()
abstract class _AuthServiceApi {
  // http://$serverHost/oauth2

  @POST('/login/{socialLoginType}')
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
        authorizationHeader = await _getAppleAuthorizationCode();
        break;

      case SocialLoginType.kakao:
        authorizationHeader = await _getKakaoAccessToken();
        break;

      default:
        return null;
    }

    if (authorizationHeader == null) {
      return null;
    }

    return await super._socialLogin(
      authorizationHeader: "Bearer $authorizationHeader",
      socialLoginType: socialLoginType,
    );
  }

  Future<String?> _getAppleAuthorizationCode() async {
    String? appleAuthorizationCode;

    try {
      appleAuthorizationCode = (await SignInWithApple.getAppleIDCredential(
        scopes: [],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: dotenv.env['APPLE_LOGIN_CLIENT_ID'] ?? '',
          redirectUri: Uri.parse(
            'https://${Constants.serverHost}/callback',
          ),
        ),
      ))
          .authorizationCode;
    } catch (e) {
      print(e);
    }

    return appleAuthorizationCode;
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
