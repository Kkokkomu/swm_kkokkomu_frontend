// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormCommentModel _$ShortFormCommentModelFromJson(
        Map<String, dynamic> json) =>
    ShortFormCommentModel(
      user: json['user'] == null
          ? null
          : ShortFormCommentUserInfo.fromJson(
              json['user'] as Map<String, dynamic>),
      comment: json['comment'] == null
          ? null
          : ShortFormCommentInfo.fromJson(
              json['comment'] as Map<String, dynamic>),
      replyCnt: (json['replyCnt'] as num?)?.toInt(),
      commentLikeCnt: (json['commentLikeCnt'] as num?)?.toInt(),
      userLike: json['userLike'] as bool?,
    );

Map<String, dynamic> _$ShortFormCommentModelToJson(
        ShortFormCommentModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'comment': instance.comment,
      'replyCnt': instance.replyCnt,
      'commentLikeCnt': instance.commentLikeCnt,
      'userLike': instance.userLike,
    };

ShortFormCommentUserInfo _$ShortFormCommentUserInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormCommentUserInfo(
      id: (json['id'] as num?)?.toInt(),
      profileImg: json['profileImg'] as String?,
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$ShortFormCommentUserInfoToJson(
        ShortFormCommentUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileImg': instance.profileImg,
      'nickname': instance.nickname,
    };

ShortFormCommentInfo _$ShortFormCommentInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormCommentInfo(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      newsId: (json['newsId'] as num?)?.toInt(),
      content: json['content'] as String?,
      editedAt: json['editedAt'] as String?,
    );

Map<String, dynamic> _$ShortFormCommentInfoToJson(
        ShortFormCommentInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'newsId': instance.newsId,
      'content': instance.content,
      'editedAt': instance.editedAt,
    };
