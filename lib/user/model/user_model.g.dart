// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      nickname: json['nickname'] as String?,
      email: json['email'] as String?,
      isPremium: json['isPremium'] as bool?,
      premiumEndDate: json['premiumEndDate'] as String?,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
      'isPremium': instance.isPremium,
      'premiumEndDate': instance.premiumEndDate,
      'profileImg': instance.profileImg,
    };
