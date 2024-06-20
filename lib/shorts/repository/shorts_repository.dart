import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shorts_model.dart';

part 'shorts_repository.g.dart';

final shortsRepositoryProvider = Provider<ShortsRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = ShortsRepository(dio, baseUrl: 'http://test');

  return repository;
});

@RestApi()
abstract class ShortsRepository {
  factory ShortsRepository(Dio dio, {String baseUrl}) = _ShortsRepository;

  @GET('/')
  Future<List<ShortsModel>> getShortsInfos();
}
