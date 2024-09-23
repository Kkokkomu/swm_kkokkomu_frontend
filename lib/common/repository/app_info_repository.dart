import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';

part 'app_info_repository.g.dart';

final appInfoRepositoryProvider = Provider<AppInfoRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return AppInfoRepository(
      dio,
      baseUrl: Constants.appInfoUrl,
    );
  },
);

@RestApi()
abstract class AppInfoRepository {
  factory AppInfoRepository(Dio dio, {String baseUrl}) = _AppInfoRepository;

  @GET('')
  Future<LatestAppInfo> getLatestAppInfo();
}
