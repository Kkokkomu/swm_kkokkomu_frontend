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
import 'package:swm_kkokkomu_frontend/notification/model/notification_log_model.dart';

part 'notification_log_repository.g.dart';

final notificationLogRepositoryProvider =
    Provider<NotificationLogRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return NotificationLogRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class NotificationLogRepository
    implements IBaseCursorPaginationRepository<NotificationLogModel> {
  factory NotificationLogRepository(Dio dio, {String baseUrl}) =
      _NotificationLogRepository;

  @override
  @GET('/alarmLog/list')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<CursorPagination<NotificationLogModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams,
    @Path() String apiPath, {
    @Queries() AdditionalParams? additionalParams,
  });
}
