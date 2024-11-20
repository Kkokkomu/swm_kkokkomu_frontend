import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';

part 'notification_detail_model.g.dart';

sealed class NotificationDetailModelBase {}

class NotificationDetailModelLoading extends NotificationDetailModelBase {}

class NotificationDetailModelError extends NotificationDetailModelBase {
  final String message;

  NotificationDetailModelError(this.message);
}

@JsonSerializable()
class NotificationDetailModel extends NotificationDetailModelBase {
  final int id;
  final String title;
  final String body;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime editedAt;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime createdAt;

  NotificationDetailModel({
    int? id,
    String? title,
    String? body,
    required this.editedAt,
    required this.createdAt,
  })  : id = id ?? Constants.unknownErrorId,
        title = title ?? Constants.unknownErrorString,
        body = body ?? Constants.unknownErrorString;

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailModelFromJson(json);
}
