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
import 'package:swm_kkokkomu_frontend/my_log/model/my_reaction_log_model.dart';

part 'my_reaction_log_repository.g.dart';

final myReactionLogRepositoryProvider =
    Provider<MyReactionLogRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return MyReactionLogRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class MyReactionLogRepository
    implements IBaseCursorPaginationRepository<MyReactionLogModel> {
  factory MyReactionLogRepository(Dio dio, {String baseUrl}) =
      _MyReactionLogRepository;

  @override
  @GET('/mypage/log/reaction')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<MyReactionLogModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });
}
