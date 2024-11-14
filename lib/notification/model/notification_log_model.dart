import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/shortform_reply_model.dart';

part 'notification_log_model.g.dart';

@JsonSerializable()
class NotificationLogModel implements IModelWithId {
  @override
  final int id;
  final int alarmLogId;
  final bool isRead;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime createdAt;
  final NotificationLogType? alarmType;
  final ShortFormReplyInfo? reply;
  final NotificationInfo? notification;

  NotificationLogModel({
    int? alarmLogId,
    bool? isRead,
    required this.createdAt,
    String? alarmType,
    this.reply,
    this.notification,
  })  : id = alarmLogId ?? Constants.unknownErrorId,
        alarmLogId = alarmLogId ?? Constants.unknownErrorId,
        isRead = isRead ?? false,
        alarmType =
            alarmType != null ? NotificationLogType.fromName(alarmType) : null;

  factory NotificationLogModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationLogModelFromJson(json);
}

@JsonSerializable()
class NotificationInfo {
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

  NotificationInfo({
    int? id,
    String? title,
    String? body,
    required this.editedAt,
    required this.createdAt,
  })  : id = id ?? Constants.unknownErrorId,
        title = title ?? Constants.unknownErrorString,
        body = body ?? Constants.unknownErrorString;

  factory NotificationInfo.fromJson(Map<String, dynamic> json) =>
      _$NotificationInfoFromJson(json);
}
