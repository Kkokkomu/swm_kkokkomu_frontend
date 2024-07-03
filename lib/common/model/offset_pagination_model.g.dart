// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offset_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffsetPagination<T> _$OffsetPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    OffsetPagination<T>(
      pageInfo: OffsetPaginationMeta.fromJson(
          json['pageInfo'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$OffsetPaginationToJson<T>(
  OffsetPagination<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'pageInfo': instance.pageInfo,
      'items': instance.items.map(toJsonT).toList(),
    };

OffsetPaginationMeta _$OffsetPaginationMetaFromJson(
        Map<String, dynamic> json) =>
    OffsetPaginationMeta(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      isLast: json['isLast'] as bool,
    );

Map<String, dynamic> _$OffsetPaginationMetaToJson(
        OffsetPaginationMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'totalPages': instance.totalPages,
      'isLast': instance.isLast,
    };
