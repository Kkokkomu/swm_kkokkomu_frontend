// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailUserModel _$DetailUserModelFromJson(Map<String, dynamic> json) =>
    DetailUserModel(
      id: (json['id'] as num?)?.toInt(),
      profileUrl: json['profileUrl'] as String?,
      nickname: json['nickname'] as String?,
      email: json['email'] as String?,
      sex: $enumDecodeNullable(_$GenderTypeEnumMap, json['sex']),
      birthday: CustomDateUtils.parseDateTime(json['birthday'] as String?),
      createdAt: json['createdAt'] as String?,
      editedAt: json['editedAt'] as String?,
      profileEditedAt: json['profileEditedAt'] as String?,
    );

Map<String, dynamic> _$DetailUserModelToJson(DetailUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileUrl': instance.profileUrl,
      'nickname': instance.nickname,
      'email': instance.email,
      'sex': _$GenderTypeEnumMap[instance.sex]!,
      'birthday': CustomDateUtils.formatDateTime(instance.birthday),
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'profileEditedAt': instance.profileEditedAt,
    };

const _$GenderTypeEnumMap = {
  GenderType.man: 'MAN',
  GenderType.woman: 'WOMAN',
  GenderType.none: 'NONE',
};
