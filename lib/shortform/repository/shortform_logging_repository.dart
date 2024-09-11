import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'shortform_logging_repository.g.dart';

final shortFormLoggingRepositoryProvider =
    Provider<ShortFormLoggingRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = ShortFormLoggingRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/home/news',
  );

  return repository;
});

@RestApi()
abstract class ShortFormLoggingRepository {
  factory ShortFormLoggingRepository(Dio dio, {String baseUrl}) =
      _ShortFormLoggingRepository;

  @POST('/shared')
  Future<ResponseModel<ShortFormNewsInfo?>> logNewsShare({
    @Body() required PostNewsIdBody body,
  });
}
