// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hide_user_response_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HideUserResponseDataModel _$HideUserResponseDataModelFromJson(
        Map<String, dynamic> json) =>
    HideUserResponseDataModel(
      reporterId: (json['reporterId'] as num?)?.toInt(),
      hidedUserId: (json['hidedUserId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HideUserResponseDataModelToJson(
        HideUserResponseDataModel instance) =>
    <String, dynamic>{
      'reporterId': instance.reporterId,
      'hidedUserId': instance.hidedUserId,
    };
