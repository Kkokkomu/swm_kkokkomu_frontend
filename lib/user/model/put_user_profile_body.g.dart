// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_user_profile_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutUserProfileBody _$PutUserProfileBodyFromJson(Map<String, dynamic> json) =>
    PutUserProfileBody(
      nickname: json['nickname'] as String,
      birthday: json['birthday'] as String,
      sex: $enumDecode(_$GenderTypeEnumMap, json['sex']),
    );

Map<String, dynamic> _$PutUserProfileBodyToJson(PutUserProfileBody instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'birthday': instance.birthday,
      'sex': _$GenderTypeEnumMap[instance.sex]!,
    };

const _$GenderTypeEnumMap = {
  GenderType.man: 'MAN',
  GenderType.woman: 'WOMAN',
  GenderType.none: 'NONE',
};
