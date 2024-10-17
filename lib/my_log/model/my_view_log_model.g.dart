// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_view_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyViewLogModel _$MyViewLogModelFromJson(Map<String, dynamic> json) =>
    MyViewLogModel(
      id: (json['id'] as num?)?.toInt(),
      news: json['news'] == null
          ? null
          : PaginationShortFormModel.fromJson(
              json['news'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyViewLogModelToJson(MyViewLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'news': instance.news,
    };
