// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_shortform_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutShortFormCommentBody _$PutShortFormCommentBodyFromJson(
        Map<String, dynamic> json) =>
    PutShortFormCommentBody(
      commentId: (json['commentId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$PutShortFormCommentBodyToJson(
        PutShortFormCommentBody instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'content': instance.content,
    };
