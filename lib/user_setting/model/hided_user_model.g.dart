// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hided_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HidedUserData _$HidedUserDataFromJson(Map<String, dynamic> json) =>
    HidedUserData(
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$HidedUserDataToJson(HidedUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'createdAt': instance.createdAt,
    };
