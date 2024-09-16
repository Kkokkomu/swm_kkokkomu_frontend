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
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'guest_user_shortform_repository.g.dart';

final guestUserShortFormRepositoryProvider =
    Provider<GuestUserShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = GuestUserShortFormRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );

  return repository;
});

@RestApi()
abstract class GuestUserShortFormRepository
    implements IBaseCursorPaginationRepository<ShortFormModel> {
  factory GuestUserShortFormRepository(Dio dio, {String baseUrl}) =
      _GuestUserShortFormRepository;

  @override
  @GET('{apiPath}')
  Future<ResponseModel<CursorPagination<ShortFormModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });
}
