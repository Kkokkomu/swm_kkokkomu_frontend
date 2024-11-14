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
      notification: json['notification'] == null
          ? null
          : NotificationInfo.fromJson(
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
      'notification': instance.notification,
    };

const _$NotificationLogTypeEnumMap = {
  NotificationLogType.notice: 'NOTICE',
  NotificationLogType.reply: 'REPLY',
  NotificationLogType.newsArticle: 'NEWS_ARTICLE',
  NotificationLogType.test: 'TEST',
};

NotificationInfo _$NotificationInfoFromJson(Map<String, dynamic> json) =>
    NotificationInfo(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      editedAt: CustomDateUtils.parseDateTime(json['editedAt'] as String?),
      createdAt: CustomDateUtils.parseDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$NotificationInfoToJson(NotificationInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'editedAt': CustomDateUtils.formatDateTime(instance.editedAt),
      'createdAt': CustomDateUtils.formatDateTime(instance.createdAt),
    };
