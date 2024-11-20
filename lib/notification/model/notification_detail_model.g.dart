// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDetailModel _$NotificationDetailModelFromJson(
        Map<String, dynamic> json) =>
    NotificationDetailModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      editedAt: CustomDateUtils.parseDateTime(json['editedAt'] as String?),
      createdAt: CustomDateUtils.parseDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$NotificationDetailModelToJson(
        NotificationDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'editedAt': CustomDateUtils.formatDateTime(instance.editedAt),
      'createdAt': CustomDateUtils.formatDateTime(instance.createdAt),
    };
