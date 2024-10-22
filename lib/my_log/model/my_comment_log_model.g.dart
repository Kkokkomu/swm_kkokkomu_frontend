// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_comment_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCommentLogModel _$MyCommentLogModelFromJson(Map<String, dynamic> json) =>
    MyCommentLogModel(
      comment: json['comment'] == null
          ? null
          : MyCommentLogInfo.fromJson(json['comment'] as Map<String, dynamic>),
      news: json['news'] == null
          ? null
          : MyCommentLogShortFormInfo.fromJson(
              json['news'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyCommentLogModelToJson(MyCommentLogModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'news': instance.news,
    };

MyCommentLogInfo _$MyCommentLogInfoFromJson(Map<String, dynamic> json) =>
    MyCommentLogInfo(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      newsId: (json['newsId'] as num?)?.toInt(),
      content: json['content'] as String?,
      editedAt: CustomDateUtils.parseDateTime(json['editedAt'] as String?),
      parentId: (json['parentId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MyCommentLogInfoToJson(MyCommentLogInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'newsId': instance.newsId,
      'content': instance.content,
      'editedAt': CustomDateUtils.formatDateTime(instance.editedAt),
      'parentId': instance.parentId,
    };

MyCommentLogShortFormInfo _$MyCommentLogShortFormInfoFromJson(
        Map<String, dynamic> json) =>
    MyCommentLogShortFormInfo(
      info: json['info'] == null
          ? null
          : ShortFormInfo.fromJson(json['info'] as Map<String, dynamic>),
      reactionCnt: json['reactionCnt'] == null
          ? null
          : ShortFormReactionCountInfo.fromJson(
              json['reactionCnt'] as Map<String, dynamic>),
      userReaction: json['userReaction'] == null
          ? null
          : ShortFormUserReactionInfo.fromJson(
              json['userReaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyCommentLogShortFormInfoToJson(
        MyCommentLogShortFormInfo instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reactionCnt': instance.reactionCnt,
      'userReaction': instance.userReaction,
    };
