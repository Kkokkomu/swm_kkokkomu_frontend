import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shortform_model.dart';

part 'shortform_repository.g.dart';

final shortFormRepositoryProvider = Provider<ShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = ShortFormRepository(dio, baseUrl: 'http://$ip/news');

  return repository;
});

@RestApi()
abstract class ShortFormRepository
    implements BasePaginationRepository<ShortFormModel> {
  factory ShortFormRepository(Dio dio, {String baseUrl}) = _ShortFormRepository;

  @override
  @GET('')
  Future<ResponseModel<OffsetPagination<ShortFormModel>>> paginate({
    @Queries() required PaginationParams paginationParams,
    @Queries() AdditionalParams? additionalParams,
  });
}
