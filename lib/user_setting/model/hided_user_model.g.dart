// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hided_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HidedUserModel _$HidedUserModelFromJson(Map<String, dynamic> json) =>
    HidedUserModel(
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$HidedUserModelToJson(HidedUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'createdAt': instance.createdAt,
    };
