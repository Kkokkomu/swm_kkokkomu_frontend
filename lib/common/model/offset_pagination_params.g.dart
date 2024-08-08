// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offset_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffsetPaginationParams _$OffsetPaginationParamsFromJson(
        Map<String, dynamic> json) =>
    OffsetPaginationParams(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$OffsetPaginationParamsToJson(
        OffsetPaginationParams instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
    };
