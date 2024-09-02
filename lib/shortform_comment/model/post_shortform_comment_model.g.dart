// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_shortform_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostShortFormCommentBody _$PostShortFormCommentBodyFromJson(
        Map<String, dynamic> json) =>
    PostShortFormCommentBody(
      newsId: (json['newsId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$PostShortFormCommentBodyToJson(
        PostShortFormCommentBody instance) =>
    <String, dynamic>{
      'newsId': instance.newsId,
      'content': instance.content,
    };
