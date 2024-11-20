// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationLogModel _$NotificationLogModelFromJson(
        Map<String, dynamic> json) =>
    NotificationLogModel(
      alarmLogId: (json['alarmLogId'] as num?)?.toInt(),
      isRead: json['isRead'] as bool?,
      createdAt: CustomDateUtils.parseDateTime(json['createdAt'] as String?),
      alarmType: json['alarmType'] as String?,
      reply: json['reply'] == null
          ? null
          : ShortFormReplyInfo.fromJson(json['reply'] as Map<String, dynamic>),
      shortFormUrl: json['shortFormUrl'] as String?,
      notification: json['notification'] == null
          ? null
          : NotificationDetailModel.fromJson(
              json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationLogModelToJson(
        NotificationLogModel instance) =>
    <String, dynamic>{
      'alarmLogId': instance.alarmLogId,
      'isRead': instance.isRead,
      'createdAt': CustomDateUtils.formatDateTime(instance.createdAt),
      'alarmType': _$NotificationLogTypeEnumMap[instance.alarmType],
      'reply': instance.reply,
      'shortFormUrl': instance.shortFormUrl,
      'notification': instance.notification,
    };

const _$NotificationLogTypeEnumMap = {
  NotificationLogType.notice: 'NOTICE',
  NotificationLogType.reply: 'REPLY',
  NotificationLogType.newsArticle: 'NEWS_ARTICLE',
  NotificationLogType.test: 'TEST',
};
