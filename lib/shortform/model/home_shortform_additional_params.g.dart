// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_shortform_additional_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeShortFormAdditionalParams _$HomeShortFormAdditionalParamsFromJson(
        Map<String, dynamic> json) =>
    HomeShortFormAdditionalParams(
      filter: $enumDecode(_$ShortFormSortTypeEnumMap, json['filter']),
    );

Map<String, dynamic> _$HomeShortFormAdditionalParamsToJson(
        HomeShortFormAdditionalParams instance) =>
    <String, dynamic>{
      'filter': _$ShortFormSortTypeEnumMap[instance.filter]!,
    };

const _$ShortFormSortTypeEnumMap = {
  ShortFormSortType.recommend: 'RECOMMEND',
  ShortFormSortType.latest: 'LATEST',
};
