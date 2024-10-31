import 'package:json_annotation/json_annotation.dart';

part 'put_user_notification_setting_body.g.dart';

@JsonSerializable()
class PutUserNotificationSettingBody {
  final bool nightAlarmYn;
  final bool alarmNewContentYn;
  final bool alarmReplyYn;
  final bool alarmInformYn;

  PutUserNotificationSettingBody({
    required this.nightAlarmYn,
    required this.alarmNewContentYn,
    required this.alarmReplyYn,
    required this.alarmInformYn,
  });

  Map<String, dynamic> toJson() => _$PutUserNotificationSettingBodyToJson(this);
}
