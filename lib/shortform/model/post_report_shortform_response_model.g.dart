// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_report_shortform_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReportShortformResponseModel _$PostReportShortformResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostReportShortformResponseModel(
      reportId: (json['reportId'] as num?)?.toInt(),
      reason: $enumDecodeNullable(_$ShortFormReportTypeEnumMap, json['reason']),
      reporterId: (json['reporterId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$PostReportShortformResponseModelToJson(
        PostReportShortformResponseModel instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'reason': _$ShortFormReportTypeEnumMap[instance.reason]!,
      'reporterId': instance.reporterId,
      'createdAt': instance.createdAt,
    };

const _$ShortFormReportTypeEnumMap = {
  ShortFormReportType.misinformation: 'MISINFORMATION',
  ShortFormReportType.violent: 'VIOLENT',
  ShortFormReportType.porno: 'PORNO',
  ShortFormReportType.legal: 'LEGAL',
  ShortFormReportType.spam: 'SPAM',
};
