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

part 'logged_in_user_shortform_comment_repository.g.dart';

final loggedInUserShortFormCommentRepositoryProvider =
    Provider<LoggedInUserShortFormCommentRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return LoggedInUserShortFormCommentRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/comment',
  );
});

@RestApi()
abstract class LoggedInUserShortFormCommentRepository
    implements IBaseCursorPaginationRepository<ShortFormCommentModel> {
  factory LoggedInUserShortFormCommentRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserShortFormCommentRepository;

  @override
  @GET('{apiPath}')
  @Headers({
    'accessToken': 'true',
  })
  Future<ResponseModel<CursorPagination<ShortFormCommentModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams, {
    @Queries() AdditionalParams? additionalParams,
    @Path() String apiPath = '',
  });
}
