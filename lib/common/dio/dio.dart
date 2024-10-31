import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/token_response_model.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/user/provider/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomIntercepter(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomIntercepter extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomIntercepter({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('[REQ] [${options.method}] ${options.uri}');
    debugPrint(
        '[REQ] [${options.method}] [Initial Headers] ${options.headers}');

    if (options.headers['accessToken'] == true) {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final accessToken =
          await storage.read(key: SecureStorageKeys.accessTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'Authorization': 'Bearer $accessToken',
      });
    }

    if (options.headers['refreshToken'] == true) {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final refreshToken =
          await storage.read(key: SecureStorageKeys.refreshTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'Authorization': 'Bearer $refreshToken',
      });
    }

    debugPrint(
        '[REQ] [${options.method}] [Adjusted Headers] ${options.headers}');
    debugPrint('[REQ] [${options.method}] [Data] ${options.data}');

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '[RES] [${response.requestOptions.method}] [Data] ${response.data}');
    debugPrint(
        '[RES] [${response.requestOptions.method}] [${response.statusCode}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        '[ERR] [${err.requestOptions.method}] [${err.response?.statusCode}] ${err.requestOptions.uri}');

    // 401에러가 났을때 (인증 오류)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    final tokenRefreshUrl = '${Constants.baseUrl}/oauth2/refresh';
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.uri.toString() == tokenRefreshUrl;

    if (isStatus401 && !isPathRefresh) {
      // 에러 코드가 401이고 (인증 오류)
      // 요청이 refresh 토큰을 요청하는 요청이 아닌 경우 (재귀적인 요청을 방지)
      // refresh 토큰을 이용해 새로운 access 토큰을 요청하고 다시 요청을 보낸다.
      // Interceptor 로직이 없는 새로운 Dio 인스턴스를 생성해 요청을 보낸다. (재귀적인 요청을 방지)
      debugPrint('토큰 재발급 후 재요청 로직 작동');

      final dio = Dio();

      final refreshToken =
          await storage.read(key: SecureStorageKeys.refreshTokenKey);

      try {
        if (refreshToken == null) {
          // refresh 토큰이 없는 경우
          throw Exception('refreshToken이 없습니다.');
        }

        final tokenRefreshRequestOption = RequestOptions(
          path: tokenRefreshUrl,
          method: 'POST',
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        );

        debugPrint(
            '[REFRESH REQ] [${tokenRefreshRequestOption.method}] ${tokenRefreshRequestOption.uri}');
        debugPrint(
            '[REFRESH REQ] [${tokenRefreshRequestOption.method}] [Headers] ${tokenRefreshRequestOption.headers}');

        final tokenRefreshResponse = await dio.fetch(tokenRefreshRequestOption);

        debugPrint(
            '[REFRESH RES] [${tokenRefreshResponse.requestOptions.method}] [Data] ${tokenRefreshResponse.data}');
        debugPrint(
            '[REFRESH RES] [${tokenRefreshResponse.requestOptions.method}] [${tokenRefreshResponse.statusCode}] ${tokenRefreshResponse.requestOptions.uri}');

        final tokenResponse = ResponseModel<TokenResponseModel?>.fromJson(
          tokenRefreshResponse.data!,
          (json) => json == null
              ? null
              : TokenResponseModel.fromJson(json as Map<String, dynamic>),
        );

        final newAccessToken = tokenResponse.data?.accessToken;
        final newRefreshToken = tokenResponse.data?.refreshToken;

        // 토큰 재발급 실패
        if (tokenResponse.success != true || newAccessToken == null) {
          throw Exception('토큰 재발급에 실패했습니다.');
        }

        // 토큰 재발급 성공
        // 토큰 변경하기
        await storage.write(
          key: SecureStorageKeys.accessTokenKey,
          value: newAccessToken,
        );
        if (newRefreshToken != null) {
          // refreshToken도 재발급 받은 경우 (refreshToken이 null이 아닌 경우)
          await storage.write(
            key: SecureStorageKeys.refreshTokenKey,
            value: newRefreshToken,
          );
        }

        // 토큰 갱신 성공했다면 fcmToken도 갱신 요청
        _refreshFcmToken(newAccessToken);

        // 재발급 받은 토큰으로 요청 재전송
        final retryOptions = err.requestOptions;
        retryOptions.headers.addAll(
          {
            'Authorization': 'Bearer $newAccessToken',
          },
        );

        debugPrint('[RETRY REQ] [${retryOptions.method}] ${retryOptions.uri}');
        debugPrint(
            '[RETRY REQ] [${retryOptions.method}] [Headers] ${retryOptions.headers}');
        debugPrint(
            '[RETRY REQ] [${retryOptions.method}] [Data] ${retryOptions.data}');

        final retryResponse = await dio.fetch(retryOptions);

        debugPrint(
            '[RETRY RES] [${retryResponse.requestOptions.method}] [Data] ${retryResponse.data}');
        debugPrint(
            '[RETRY RES] [${retryResponse.requestOptions.method}] [${retryResponse.statusCode}] ${retryResponse.requestOptions.uri}');

        // 재요청 성공
        debugPrint('토큰 재발급 후 재요청 로직 성공');
        return handler.resolve(retryResponse);
      } catch (e) {
        // 토큰 재발급 후 재요청 실패
        debugPrint(e.toString());
        debugPrint('토큰 재발급 후 재요청 로직 실패');

        final isLogoutRequest = err.requestOptions.toString() ==
            '${Constants.baseUrl}/oauth2/logout';

        final isDeleteTokenRequest = err.requestOptions.toString() ==
                '${Constants.baseUrl}/alarm/token' &&
            err.requestOptions.method == 'DELETE';

        // 토큰이 유효하지 않으므로 로그아웃 처리를 해줘야 함
        // 요청이 로그아웃 요청이 아니었을 경우에만 로그아웃 로직을 실행
        // 요청이 로그아웃 요청이었을 경우 추가적으로 로그아웃 로직을 한번 더 실행할 필요 없음
        // 토큰 삭제 요청을 하다 에러가 발생한 경우에는 강제 로그아웃 로직을 실행하지 않음
        // 토큰 삭제 요청을 했다는 것은 이미 로그아웃 로직이 실행되었음을 의미
        if (!isLogoutRequest && !isDeleteTokenRequest) {
          // 요청이 로그아웃 요청 또는 토큰 삭제 요청이 아닌 경우
          // 로그아웃 로직 실행
          ref.read(authProvider.notifier).authErrorLogout();
        }
      }
    }

    // 에러를 해결하지 못한 경우
    // 에러를 ResponseModel로 파싱할 수 있는 형식으로 반환
    return handler.resolve(
      Response<Map<String, dynamic>>(
        requestOptions: err.requestOptions,
        data: {
          'success': false,
          'data': null,
          'error': {
            'code': err.response?.statusCode.toString() ??
                CustomErrorCode.unknownCode,
            'message': err.toString(),
          },
        },
      ),
    );
  }

  Future<void> _refreshFcmToken(String accessToken) async {
    try {
      // fcmToken을 가져옴
      final fcmToken =
          await ref.read(pushNotificationServiceProvider).getToken();

      // fcmToken이 null인 경우, 갱신 요청을 보내지 않음
      // fcmToken이 null이 아닌 경우에만 fcmToken 갱신 요청
      if (fcmToken == null) {
        return;
      }

      final dio = Dio();

      // fcmToken 갱신 요청 옵션
      final fcmTokenRefreshRequestOption = RequestOptions(
        path: '${Constants.baseUrl}/alarm/token',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'fcmToken': fcmToken,
        },
      );

      debugPrint(
          '[REFRESH FCM REQ] [${fcmTokenRefreshRequestOption.method}] ${fcmTokenRefreshRequestOption.uri}');
      debugPrint(
          '[REFRESH FCM REQ] [${fcmTokenRefreshRequestOption.method}] [Headers] ${fcmTokenRefreshRequestOption.headers}');
      debugPrint(
          '[REFRESH FCM REQ] [${fcmTokenRefreshRequestOption.method}] [Data] ${fcmTokenRefreshRequestOption.data}');

      // fcmToken 갱신 요청
      final fcmTokenRefreshResponse =
          await dio.fetch(fcmTokenRefreshRequestOption);

      debugPrint(
          '[REFRESH FCM RES] [${fcmTokenRefreshResponse.requestOptions.method}] [Data] ${fcmTokenRefreshResponse.data}');
      debugPrint(
          '[REFRESH FCM RES] [${fcmTokenRefreshResponse.requestOptions.method}] [${fcmTokenRefreshResponse.statusCode}] ${fcmTokenRefreshResponse.requestOptions.uri}');
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('[REFRESH FCM FAIL] FCM Token 갱신에 실패');
    }
  }
}
