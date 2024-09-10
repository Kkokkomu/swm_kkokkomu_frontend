// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_detail_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormDetailInfoModel _$ShortFormDetailInfoModelFromJson(
        Map<String, dynamic> json) =>
    ShortFormDetailInfoModel(
      news: json['news'] == null
          ? null
          : ShortFormDetailNewsInfo.fromJson(
              json['news'] as Map<String, dynamic>),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ShortFormDetailInfoModelToJson(
        ShortFormDetailInfoModel instance) =>
    <String, dynamic>{
      'news': instance.news,
      'keywords': instance.keywords,
    };

ShortFormDetailNewsInfo _$ShortFormDetailNewsInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormDetailNewsInfo(
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

Map<String, dynamic> _$ShortFormDetailNewsInfoToJson(
        ShortFormDetailNewsInfo instance) =>
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
      'category': _$NewsCategoryEnumMap[instance.category],
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
