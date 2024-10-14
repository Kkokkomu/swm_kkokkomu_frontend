// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_shortform_additional_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchShortFormAdditionalParams _$SearchShortFormAdditionalParamsFromJson(
        Map<String, dynamic> json) =>
    SearchShortFormAdditionalParams(
      text: json['text'] as String,
      category: json['category'] as String,
      filter: $enumDecode(_$ShortFormSortTypeEnumMap, json['filter']),
    );

Map<String, dynamic> _$SearchShortFormAdditionalParamsToJson(
        SearchShortFormAdditionalParams instance) =>
    <String, dynamic>{
      'text': instance.text,
      'category': instance.category,
      'filter': _$ShortFormSortTypeEnumMap[instance.filter]!,
    };

const _$ShortFormSortTypeEnumMap = {
  ShortFormSortType.recommend: 'RECOMMEND',
  ShortFormSortType.latest: 'LATEST',
};
