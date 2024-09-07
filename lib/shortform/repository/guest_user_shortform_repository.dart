import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_offset_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'guest_user_shortform_repository.g.dart';

final guestUserShortFormRepositoryProvider =
    Provider<GuestUserShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = GuestUserShortFormRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/home/news',
  );

  return repository;
});

@RestApi()
abstract class GuestUserShortFormRepository
    implements BaseOffsetPaginationRepository<ShortFormModel> {
  factory GuestUserShortFormRepository(Dio dio, {String baseUrl}) =
      _GuestUserShortFormRepository;

  @override
  @GET('/list/guest')
  Future<ResponseModel<OffsetPagination<ShortFormModel>>> paginate(
    @Queries() OffsetPaginationParams offsetPaginationParams, {
    @Queries() AdditionalParams? additionalParams,
  });
}
