// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_shortform_category_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchShortFormCategoryFilterModel _$SearchShortFormCategoryFilterModelFromJson(
        Map<String, dynamic> json) =>
    SearchShortFormCategoryFilterModel(
      politics: json['politics'] as bool?,
      economy: json['economy'] as bool?,
      social: json['social'] as bool?,
      entertain: json['entertain'] as bool?,
      sports: json['sports'] as bool?,
      living: json['living'] as bool?,
      world: json['world'] as bool?,
      it: json['it'] as bool?,
    );

Map<String, dynamic> _$SearchShortFormCategoryFilterModelToJson(
        SearchShortFormCategoryFilterModel instance) =>
    <String, dynamic>{
      'politics': instance.politics,
      'economy': instance.economy,
      'social': instance.social,
      'entertain': instance.entertain,
      'sports': instance.sports,
      'living': instance.living,
      'world': instance.world,
      'it': instance.it,
    };
