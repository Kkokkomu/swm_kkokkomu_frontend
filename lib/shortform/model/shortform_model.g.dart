// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormModel _$ShortFormModelFromJson(Map<String, dynamic> json) =>
    ShortFormModel(
      shortForm: json['shortForm'] == null
          ? null
          : ShortFormUrlInfo.fromJson(
              json['shortForm'] as Map<String, dynamic>),
      reaction: json['reaction'] == null
          ? null
          : ShortFormReactionInfo.fromJson(
              json['reaction'] as Map<String, dynamic>),
      reactionWithUser: json['reactionWithUser'] == null
          ? null
          : ShortFormReactionWithUserInfo.fromJson(
              json['reactionWithUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShortFormModelToJson(ShortFormModel instance) =>
    <String, dynamic>{
      'shortForm': instance.shortForm,
      'reaction': instance.reaction,
      'reactionWithUser': instance.reactionWithUser,
    };

ShortFormUrlInfo _$ShortFormUrlInfoFromJson(Map<String, dynamic> json) =>
    ShortFormUrlInfo(
      id: (json['id'] as num?)?.toInt(),
      shortformUrl: json['shortformUrl'] as String?,
      youtubeUrl: json['youtubeUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      relatedUrl: json['relatedUrl'] as String?,
    );

Map<String, dynamic> _$ShortFormUrlInfoToJson(ShortFormUrlInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortformUrl': instance.shortformUrl,
      'youtubeUrl': instance.youtubeUrl,
      'instagramUrl': instance.instagramUrl,
      'relatedUrl': instance.relatedUrl,
    };

ShortFormReactionInfo _$ShortFormReactionInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormReactionInfo(
      great: (json['great'] as num?)?.toInt(),
      hate: (json['hate'] as num?)?.toInt(),
      expect: (json['expect'] as num?)?.toInt(),
      surprise: (json['surprise'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShortFormReactionInfoToJson(
        ShortFormReactionInfo instance) =>
    <String, dynamic>{
      'great': instance.great,
      'hate': instance.hate,
      'expect': instance.expect,
      'surprise': instance.surprise,
    };

ShortFormReactionWithUserInfo _$ShortFormReactionWithUserInfoFromJson(
        Map<String, dynamic> json) =>
    ShortFormReactionWithUserInfo(
      great: json['great'] as bool,
      hate: json['hate'] as bool,
      expect: json['expect'] as bool,
      surprise: json['surprise'] as bool,
    );

Map<String, dynamic> _$ShortFormReactionWithUserInfoToJson(
        ShortFormReactionWithUserInfo instance) =>
    <String, dynamic>{
      'great': instance.great,
      'hate': instance.hate,
      'expect': instance.expect,
      'surprise': instance.surprise,
    };
