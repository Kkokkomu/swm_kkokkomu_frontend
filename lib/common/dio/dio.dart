import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';

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
    print('[REQ] [${options.method}] ${options.uri}');
    print('[REQ] [${options.method}] [Headers] ${options.headers}');
    print('[REQ] [${options.method}] [Data] ${options.data}');

    // if (options.headers['accessToken'] == 'true') {
    //   options.headers.remove('accessToken');

    //   final token = await storage.read(key: ACCESS_TOKEN_KEY);

    //   options.headers.addAll(
    //     {'authorization': 'Bearer $token'},
    //   );

    //   if (options.headers['refreshToken'] == 'true') {
    //     options.headers.remove('refreshToken');

    //     final token = await storage.read(key: REFRESH_TOKEN_KEY);

    //     options.headers.addAll(
    //       {'authorization': 'Bearer $token'},
    //     );
    //   }
    // }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] [Data] ${response.data}');
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.
    print(
        '[ERR] [${err.requestOptions.method}] [${err.response?.statusCode}] ${err.requestOptions.uri}');

    // final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // // refreshToken 아예 없으면
    // // 당연히 에러를 던진다
    // if (refreshToken == null) {
    //   // 에러를 던질때는 handler.reject를 사용한다.
    //   return handler.reject(err);
    // }

    // final isStatus401 = err.response?.statusCode == 401;
    // final isPathRefresh = err.requestOptions.path == '/auth/token';

    // if (isStatus401 && !isPathRefresh) {
    //   final dio = Dio();

    //   try {
    //     final resp = await dio.post(
    //       'http://$ip/auth/token',
    //       options: Options(
    //         headers: {
    //           'authorization': 'Bearer $refreshToken',
    //         },
    //       ),
    //     );

    //     final accessToken = resp.data['accessToken'];

    //     final options = err.requestOptions;

    //     options.headers.addAll(
    //       {
    //         'authorization': 'Bearer $accessToken',
    //       },
    //     );

    //     // 토큰 변경하기
    //     await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

    //     // 요청 재전송
    //     final response = await dio.fetch(options);

    //     return handler.resolve(response);
    //   } on DioError catch (e) {
    //     // circular dependency error
    //     // A, B
    //     // A -> B의 친구
    //     // B -> A의 친구
    //     // A는 B의 친구구나
    //     // A -> B -> A -> B -> A -> B
    //     // ump -> dio -> ump -> dio
    //     ref.read(authProvider.notifier).logout();

    //     return handler.reject(e);
    //   }
    // }

    return handler.resolve(
      Response<Map<String, dynamic>>(
        requestOptions: err.requestOptions,
        data: {
          'success': false,
          'data': null,
          'error': {
            'code': 99999,
            'message': '통신 에러',
          },
        },
      ),
    );
  }
}
