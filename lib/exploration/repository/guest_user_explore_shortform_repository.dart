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

part 'guest_user_explore_shortform_repository.g.dart';

final guestUserExploreShortFormRepositoryProvider =
    Provider<GuestUserExploreShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return GuestUserExploreShortFormRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class GuestUserExploreShortFormRepository
    implements IBaseCursorPaginationRepository<ShortFormModel> {
  factory GuestUserExploreShortFormRepository(Dio dio, {String baseUrl}) =
      _GuestUserExploreShortFormRepository;

  @override
  @GET('/search/news/filter/guest')
  Future<ResponseModel<CursorPagination<ShortFormModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams, {
    @Queries() AdditionalParams? additionalParams,
    @Path() String apiPath = '',
  });
}
