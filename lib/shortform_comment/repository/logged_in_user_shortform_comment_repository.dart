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
import 'package:swm_kkokkomu_frontend/shortform_comment/model/post_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/put_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_report_model.dart';

part 'logged_in_user_shortform_comment_repository.g.dart';

final loggedInUserShortFormCommentRepositoryProvider =
    Provider<LoggedInUserShortFormCommentRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return LoggedInUserShortFormCommentRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class LoggedInUserShortFormCommentRepository
    implements IBaseCursorPaginationRepository<ShortFormCommentModel> {
  factory LoggedInUserShortFormCommentRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserShortFormCommentRepository;

  @override
  @GET('/comment/{apiPath}')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<ShortFormCommentModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });

  @POST('/comment')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<ShortFormCommentInfo?>> postComment({
    @Body() required PostShortFormCommentBody body,
  });

  @PUT('/comment')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> updateComment({
    @Body() required PutShortFormCommentBody body,
  });

  @DELETE('/comment')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteComment({
    @Query('commentId') required int commentId,
  });

  @POST('/comment/like')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> postCommentLike({
    @Body() required PostShortFormCommentLikeBody body,
  });

  @DELETE('/comment/like')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteCommentLike({
    @Query('commentId') required int commentId,
  });

  @POST('/report/comment')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CommentReportResponseModel?>> reportComment({
    @Body() required PostCommentReportModel body,
  });
}
