import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_detail_info_model.dart';

part 'shortform_detail_info_repository.g.dart';

final shortFormDetailInfoRepositoryProvider =
    Provider<ShortFormDetailInfoRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = ShortFormDetailInfoRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/home/news/info',
  );

  return repository;
});

@RestApi()
abstract class ShortFormDetailInfoRepository {
  factory ShortFormDetailInfoRepository(Dio dio, {String baseUrl}) =
      _ShortFormDetailInfoRepository;

  @GET('')
  Future<ResponseModel<ShortFormDetailInfoModel?>> getDetailInfo({
    @Query('newsId') required int newsId,
  });
}
