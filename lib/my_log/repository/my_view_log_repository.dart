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
import 'package:swm_kkokkomu_frontend/my_log/model/my_view_log_model.dart';

part 'my_view_log_repository.g.dart';

final myViewLogRepositoryProvider = Provider<MyViewLogRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return MyViewLogRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class MyViewLogRepository
    implements IBaseCursorPaginationRepository<MyViewLogModel> {
  factory MyViewLogRepository(Dio dio, {String baseUrl}) = _MyViewLogRepository;

  @override
  @GET('/mypage/log/view')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<MyViewLogModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });

  @DELETE('/mypage/log/user')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteAllLog();

  @DELETE('/mypage/log/list')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteSelectedLog({
    @Query('newsIdList') required String newsIdList,
  });
}
