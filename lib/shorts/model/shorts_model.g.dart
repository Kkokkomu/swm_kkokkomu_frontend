// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortsModel _$ShortsModelFromJson(Map<String, dynamic> json) => ShortsModel(
      id: json['id'],
      shortform_url: json['shortform_url'] as String,
      related_url: json['related_url'] as String,
    );

Map<String, dynamic> _$ShortsModelToJson(ShortsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortform_url': instance.shortform_url,
      'related_url': instance.related_url,
    };
