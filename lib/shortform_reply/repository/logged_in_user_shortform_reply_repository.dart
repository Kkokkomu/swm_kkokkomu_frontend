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
import 'package:swm_kkokkomu_frontend/shortform_reply/model/post_shortform_reply_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/put_shortform_reply_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/shortform_reply_model.dart';

part 'logged_in_user_shortform_reply_repository.g.dart';

final loggedInUserShortFormReplyRepositoryProvider =
    Provider<LoggedInUserShortFormReplyRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return LoggedInUserShortFormReplyRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/comment/reply',
  );
});

@RestApi()
abstract class LoggedInUserShortFormReplyRepository
    implements IBaseCursorPaginationRepository<ShortFormCommentModel> {
  factory LoggedInUserShortFormReplyRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserShortFormReplyRepository;

  @override
  @GET('/oldest')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<ShortFormCommentModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });

  @POST('')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<ShortFormReplyInfo?>> postReply({
    @Body() required PostShortFormReplyBody body,
  });

  @PUT('')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> updateReply({
    @Body() required PutShortFormReplyBody body,
  });

  @DELETE('')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteReply({
    @Query('replyId') required int replyId,
  });
}
