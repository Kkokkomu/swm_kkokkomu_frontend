import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_detail_model.dart';

part 'notification_detail_repository.g.dart';

final notificationDetailRepositoryProvider =
    Provider<NotificationDetailRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return NotificationDetailRepository(
    dio,
    baseUrl: Constants.baseUrl,
  );
});

@RestApi()
abstract class NotificationDetailRepository {
  factory NotificationDetailRepository(Dio dio, {String baseUrl}) =
      _NotificationDetailRepository;

  @GET('/notification')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<NotificationDetailModel?>> getNotificationDetailInfo({
    @Query('notificationId') required int notificationId,
  });
}
