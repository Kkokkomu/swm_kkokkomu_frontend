import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';

part 'user_info_repository.g.dart';

final userInfoRepositoryProvider = Provider<UserInfoRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserInfoRepository(
      dio,
      baseUrl: 'http://${Constants.serverHost}/user',
    );
  },
);

@RestApi()
abstract class UserInfoRepository {
  factory UserInfoRepository(Dio dio, {String baseUrl}) = _UserInfoRepository;

  @GET('/mypage')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<UserModel?>> getUserInfo();
}
