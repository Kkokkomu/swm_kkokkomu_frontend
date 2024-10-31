// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_user_notification_setting_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutUserNotificationSettingBody _$PutUserNotificationSettingBodyFromJson(
        Map<String, dynamic> json) =>
    PutUserNotificationSettingBody(
      nightAlarmYn: json['nightAlarmYn'] as bool,
      alarmNewContentYn: json['alarmNewContentYn'] as bool,
      alarmReplyYn: json['alarmReplyYn'] as bool,
      alarmInformYn: json['alarmInformYn'] as bool,
    );

Map<String, dynamic> _$PutUserNotificationSettingBodyToJson(
        PutUserNotificationSettingBody instance) =>
    <String, dynamic>{
      'nightAlarmYn': instance.nightAlarmYn,
      'alarmNewContentYn': instance.alarmNewContentYn,
      'alarmReplyYn': instance.alarmReplyYn,
      'alarmInformYn': instance.alarmInformYn,
    };
