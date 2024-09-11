// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormModel _$ShortFormModelFromJson(Map<String, dynamic> json) =>
    ShortFormModel(
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

Map<String, dynamic> _$ShortFormModelToJson(ShortFormModel instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reactionCnt': instance.reactionCnt,
      'userReaction': instance.userReaction,
    };

ShortFormInfo _$ShortFormInfoFromJson(Map<String, dynamic> json) =>
    ShortFormInfo(
      news: json['news'] == null
          ? null
          : ShortFormNewsInfo.fromJson(json['news'] as Map<String, dynamic>),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ShortFormInfoToJson(ShortFormInfo instance) =>
    <String, dynamic>{
      'news': instance.news,
      'keywords': instance.keywords,
    };

ShortFormNewsInfo _$ShortFormNewsInfoFromJson(Map<String, dynamic> json) =>
    ShortFormNewsInfo(
      id: (json['id'] as num?)?.toInt(),
      shortformUrl: json['shortformUrl'] as String?,
      youtubeUrl: json['youtubeUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      relatedUrl: json['relatedUrl'] as String?,
      thumbnail: json['thumbnail'] as String?,
      viewCnt: (json['viewCnt'] as num?)?.toInt(),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      sharedCnt: (json['sharedCnt'] as num?)?.toInt(),
      category: $enumDecodeNullable(_$NewsCategoryEnumMap, json['category']),
      createdAt: json['createdAt'] as String?,
      editedAt: json['editedAt'] as String?,
    );

Map<String, dynamic> _$ShortFormNewsInfoToJson(ShortFormNewsInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortformUrl': instance.shortformUrl,
      'youtubeUrl': instance.youtubeUrl,
      'instagramUrl': instance.instagramUrl,
      'relatedUrl': instance.relatedUrl,
      'thumbnail': instance.thumbnail,
      'viewCnt': instance.viewCnt,
      'title': instance.title,
      'summary': instance.summary,
      'sharedCnt': instance.sharedCnt,
      'category': _$NewsCategoryEnumMap[instance.category]!,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
    };

const _$NewsCategoryEnumMap = {
  NewsCategory.politics: 'POLITICS',
  NewsCategory.economy: 'ECONOMY',
  NewsCategory.social: 'SOCIAL',
  NewsCategory.entertain: 'ENTERTAIN',
  NewsCategory.sports: 'SPORTS',
  NewsCategory.living: 'LIVING',
  NewsCategory.world: 'WORLD',
  NewsCategory.it: 'IT',
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
