// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestAppInfo _$LatestAppInfoFromJson(Map<String, dynamic> json) =>
    LatestAppInfo(
      version: json['version'] as String,
      minVersion: json['minVersion'] as String,
      url: json['url'] as String,
      blacklistedVersions: (json['blacklistedVersions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isOnline: json['isOnline'] as bool,
    );

Map<String, dynamic> _$LatestAppInfoToJson(LatestAppInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'minVersion': instance.minVersion,
      'url': instance.url,
      'blacklistedVersions': instance.blacklistedVersions,
      'isOnline': instance.isOnline,
    };
