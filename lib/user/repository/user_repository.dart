import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserRepository(
      dio,
      baseUrl: '${Constants.baseUrl}/user',
    );
  },
);

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/mypage')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<UserModel?>> getUserInfo();
}
