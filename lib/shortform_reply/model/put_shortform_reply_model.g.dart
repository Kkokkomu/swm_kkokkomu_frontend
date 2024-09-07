// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_shortform_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutShortFormReplyBody _$PutShortFormReplyBodyFromJson(
        Map<String, dynamic> json) =>
    PutShortFormReplyBody(
      replyId: (json['replyId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$PutShortFormReplyBodyToJson(
        PutShortFormReplyBody instance) =>
    <String, dynamic>{
      'replyId': instance.replyId,
      'content': instance.content,
    };
