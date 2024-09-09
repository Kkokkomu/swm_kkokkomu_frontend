// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_report_shortform_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReportShortFormBodyModel _$PostReportShortFormBodyModelFromJson(
        Map<String, dynamic> json) =>
    PostReportShortFormBodyModel(
      reason: $enumDecode(_$ShortFormReportTypeEnumMap, json['reason']),
      newsId: (json['newsId'] as num).toInt(),
    );

Map<String, dynamic> _$PostReportShortFormBodyModelToJson(
        PostReportShortFormBodyModel instance) =>
    <String, dynamic>{
      'reason': _$ShortFormReportTypeEnumMap[instance.reason]!,
      'newsId': instance.newsId,
    };

const _$ShortFormReportTypeEnumMap = {
  ShortFormReportType.misinformation: 'MISINFORMATION',
  ShortFormReportType.violent: 'VIOLENT',
  ShortFormReportType.porno: 'PORNO',
  ShortFormReportType.legal: 'LEGAL',
  ShortFormReportType.spam: 'SPAM',
};
