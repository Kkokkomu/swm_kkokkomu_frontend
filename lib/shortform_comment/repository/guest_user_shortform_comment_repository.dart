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
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';

part 'guest_user_shortform_comment_repository.g.dart';

final guestUserShortFormCommentRepositoryProvider =
    Provider<GuestUserShortFormCommentRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return GuestUserShortFormCommentRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/comment',
  );
});

@RestApi()
abstract class GuestUserShortFormCommentRepository
    implements IBaseCursorPaginationRepository<ShortFormCommentModel> {
  factory GuestUserShortFormCommentRepository(Dio dio, {String baseUrl}) =
      _GuestUserShortFormCommentRepository;

  @override
  @GET('{apiPath}')
  Future<ResponseModel<CursorPagination<ShortFormCommentModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams, {
    @Queries() AdditionalParams? additionalParams,
    @Path() String apiPath = '',
  });
}
