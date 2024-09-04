// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormModel _$ShortFormModelFromJson(Map<String, dynamic> json) =>
    ShortFormModel(
      shortformList: json['shortformList'] == null
          ? null
          : ShortFormUrlInfo.fromJson(
              json['shortformList'] as Map<String, dynamic>),
      reactionCnt: json['reactionCnt'] == null
          ? null
          : ShortFormReactionCountInfo.fromJson(
              json['reactionCnt'] as Map<String, dynamic>),
      userReaction: json['userReaction'] == null
          ? null
          : ShortFormUserReactionInfo.fromJson(
              json['userReaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShortFormModelToJson(ShortFormModel instance) =>
    <String, dynamic>{
      'shortformList': instance.shortformList,
      'reactionCnt': instance.reactionCnt,
      'userReaction': instance.userReaction,
    };

ShortFormUrlInfo _$ShortFormUrlInfoFromJson(Map<String, dynamic> json) =>
    ShortFormUrlInfo(
      id: (json['id'] as num?)?.toInt(),
      shortformUrl: json['shortformUrl'] as String?,
      relatedUrl: json['relatedUrl'] as String?,
    );

Map<String, dynamic> _$ShortFormUrlInfoToJson(ShortFormUrlInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortformUrl': instance.shortformUrl,
      'relatedUrl': instance.relatedUrl,
    };

ShortFormReactionCountInfo _$ShortFormReactionCountInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormReactionCountInfo(
      like: (json['like'] as num?)?.toInt(),
      surprise: (json['surprise'] as num?)?.toInt(),
      sad: (json['sad'] as num?)?.toInt(),
      angry: (json['angry'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShortFormReactionCountInfoToJson(
        ShortFormReactionCountInfo instance) =>
    <String, dynamic>{
      'like': instance.like,
      'surprise': instance.surprise,
      'sad': instance.sad,
      'angry': instance.angry,
    };

ShortFormUserReactionInfo _$ShortFormUserReactionInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormUserReactionInfo(
      like: json['like'] as bool?,
      surprise: json['surprise'] as bool?,
      sad: json['sad'] as bool?,
      angry: json['angry'] as bool?,
    );

Map<String, dynamic> _$ShortFormUserReactionInfoToJson(
        ShortFormUserReactionInfo instance) =>
    <String, dynamic>{
      'like': instance.like,
      'surprise': instance.surprise,
      'sad': instance.sad,
      'angry': instance.angry,
    };
