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
import 'package:swm_kkokkomu_frontend/shortform/model/post_report_shortform_body_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_report_shortform_response_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/put_post_reaction_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'logged_in_user_shortform_repository.g.dart';

final loggedInUserShortFormRepositoryProvider =
    Provider<LoggedInUserShortFormRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = LoggedInUserShortFormRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );

  return repository;
});

@RestApi()
abstract class LoggedInUserShortFormRepository
    implements IBaseCursorPaginationRepository<ShortFormModel> {
  factory LoggedInUserShortFormRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserShortFormRepository;

  @override
  @GET('{apiPath}')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<ShortFormModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });

  @POST('/news-reaction')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<PutPostReactionResponseModel?>> postReaction({
    @Body() required PutPostReactionModel body,
  });

  @PUT('/news-reaction')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<PutPostReactionResponseModel?>> updateReaction({
    @Body() required PutPostReactionModel body,
  });

  @DELETE('/news-reaction')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteReaction({
    @Query('newsId') required int newsId,
    @Query('reaction') required String reaction,
  });

  @POST('/report/news')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<PostReportShortformResponseModel?>> reportShortForm({
    @Body() required PostReportShortFormBodyModel body,
  });

  @POST('/home/news/not-interested')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<ShortFormNewsInfo?>> setNotInterested({
    @Body() required PostNewsIdBody body,
  });
}
