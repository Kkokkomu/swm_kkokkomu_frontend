import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';

part 'guest_user_pagination_shortform_repository.g.dart';

final guestUserPaginationShortFormRepositoryProvider =
    Provider<GuestUserPaginationShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = GuestUserPaginationShortFormRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );

  return repository;
});

@RestApi()
abstract class GuestUserPaginationShortFormRepository
    implements IBaseCursorPaginationRepository<PaginationShortFormModel> {
  factory GuestUserPaginationShortFormRepository(Dio dio, {String baseUrl}) =
      _GuestUserPaginationShortFormRepository;

  @override
  @GET('{apiPath}')
  Future<ResponseModel<CursorPagination<PaginationShortFormModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });
}
