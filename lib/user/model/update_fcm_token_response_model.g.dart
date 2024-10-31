// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_fcm_token_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFcmTokenResponseModel _$UpdateFcmTokenResponseModelFromJson(
        Map<String, dynamic> json) =>
    UpdateFcmTokenResponseModel(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String?,
      editedAt: CustomDateUtils.parseDateTime(json['editedAt'] as String?),
      expiredAt: CustomDateUtils.parseDateTime(json['expiredAt'] as String?),
    );

Map<String, dynamic> _$UpdateFcmTokenResponseModelToJson(
        UpdateFcmTokenResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'editedAt': CustomDateUtils.formatDateTime(instance.editedAt),
      'expiredAt': CustomDateUtils.formatDateTime(instance.expiredAt),
    };
