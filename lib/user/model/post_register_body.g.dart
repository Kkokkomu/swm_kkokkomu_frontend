// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_register_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRegisterBody _$PostRegisterBodyFromJson(Map<String, dynamic> json) =>
    PostRegisterBody(
      provider: json['provider'] as String,
      nickname: json['nickname'] as String,
      sex: $enumDecode(_$GenderTypeEnumMap, json['sex']),
      birthday: json['birthday'] as String,
      recommendCode: json['recommendCode'] as String?,
    );

Map<String, dynamic> _$PostRegisterBodyToJson(PostRegisterBody instance) {
  final val = <String, dynamic>{
    'provider': instance.provider,
    'nickname': instance.nickname,
    'sex': _$GenderTypeEnumMap[instance.sex]!,
    'birthday': instance.birthday,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recommendCode', instance.recommendCode);
  return val;
}

const _$GenderTypeEnumMap = {
  GenderType.man: 'MAN',
  GenderType.woman: 'WOMAN',
  GenderType.none: 'NONE',
};
