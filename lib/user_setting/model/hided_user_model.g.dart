// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hided_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HidedUserData _$HidedUserDataFromJson(Map<String, dynamic> json) =>
    HidedUserData(
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      profileImg: json['profileImg'] as String?,
      createdAt: CustomDateUtils.parseDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$HidedUserDataToJson(HidedUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'profileImg': instance.profileImg,
      'createdAt': CustomDateUtils.formatDateTime(instance.createdAt),
    };
