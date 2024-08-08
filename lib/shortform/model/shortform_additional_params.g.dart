// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_additional_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortFormAdditionalParams _$ShortFormAdditionalParamsFromJson(
        Map<String, dynamic> json) =>
    ShortFormAdditionalParams(
      category: json['category'] as String,
      filter: $enumDecode(_$ShortFormSortTypeEnumMap, json['filter']),
    );

Map<String, dynamic> _$ShortFormAdditionalParamsToJson(
        ShortFormAdditionalParams instance) =>
    <String, dynamic>{
      'category': instance.category,
      'filter': _$ShortFormSortTypeEnumMap[instance.filter]!,
    };

const _$ShortFormSortTypeEnumMap = {
  ShortFormSortType.recommend: 'RECOMMEND',
  ShortFormSortType.latest: 'LATEST',
};
