// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_shortform_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostShortFormReplyBody _$PostShortFormReplyBodyFromJson(
        Map<String, dynamic> json) =>
    PostShortFormReplyBody(
      newsId: (json['newsId'] as num).toInt(),
      commentId: (json['commentId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$PostShortFormReplyBodyToJson(
        PostShortFormReplyBody instance) =>
    <String, dynamic>{
      'newsId': instance.newsId,
      'commentId': instance.commentId,
      'content': instance.content,
    };
