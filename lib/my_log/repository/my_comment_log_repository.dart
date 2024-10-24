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
import 'package:swm_kkokkomu_frontend/my_log/model/my_comment_log_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/put_shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/put_shortform_reply_model.dart';

part 'my_comment_log_repository.g.dart';

final myCommentLogRepositoryProvider = Provider<MyCommentLogRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return MyCommentLogRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class MyCommentLogRepository
    implements IBaseCursorPaginationRepository<MyCommentLogModel> {
  factory MyCommentLogRepository(Dio dio, {String baseUrl}) =
      _MyCommentLogRepository;

  @override
  @GET('/mypage/log/commented')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<MyCommentLogModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });

  @DELETE('/comment')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteComment({
    @Query('commentId') required int commentId,
  });

  @DELETE('/comment/reply')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteReply({
    @Query('replyId') required int replyId,
  });
}
