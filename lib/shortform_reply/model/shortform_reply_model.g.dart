// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormReplyInfo _$ShortFormReplyInfoFromJson(Map<String, dynamic> json) =>
    ShortFormReplyInfo(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      newsId: (json['newsId'] as num?)?.toInt(),
      parentId: (json['parentId'] as num?)?.toInt(),
      content: json['content'] as String?,
      editedAt: CustomDateUtils.parseDateTime(json['editedAt'] as String?),
    );

Map<String, dynamic> _$ShortFormReplyInfoToJson(ShortFormReplyInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'newsId': instance.newsId,
      'parentId': instance.parentId,
      'content': instance.content,
      'editedAt': CustomDateUtils.formatDateTime(instance.editedAt),
    };
