// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_register_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRegisterBody _$PostRegisterBodyFromJson(Map<String, dynamic> json) =>
    PostRegisterBody(
      provider: json['provider'] as String,
      nickname: json['nickname'] as String,
      sex: json['sex'] as String,
      birthday: json['birthday'] as String,
      recommandCode: json['recommandCode'] as String?,
    );

Map<String, dynamic> _$PostRegisterBodyToJson(PostRegisterBody instance) {
  final val = <String, dynamic>{
    'provider': instance.provider,
    'nickname': instance.nickname,
    'sex': instance.sex,
    'birthday': instance.birthday,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recommandCode', instance.recommandCode);
  return val;
}
