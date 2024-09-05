// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortform_comment_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentReportModel _$PostCommentReportModelFromJson(
        Map<String, dynamic> json) =>
    PostCommentReportModel(
      reason: $enumDecode(_$CommentReportTypeEnumMap, json['reason']),
      commentId: (json['commentId'] as num).toInt(),
    );

Map<String, dynamic> _$PostCommentReportModelToJson(
        PostCommentReportModel instance) =>
    <String, dynamic>{
      'reason': _$CommentReportTypeEnumMap[instance.reason]!,
      'commentId': instance.commentId,
    };

const _$CommentReportTypeEnumMap = {
  CommentReportType.offensive: 'OFFENSIVE',
  CommentReportType.profane: 'PROFANE',
  CommentReportType.violent: 'VIOLENT',
  CommentReportType.porno: 'PORNO',
  CommentReportType.spam: 'SPAM',
};

CommentReportResponseModel _$CommentReportResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommentReportResponseModel(
      reportId: (json['reportId'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      reporterId: (json['reporterId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$CommentReportResponseModelToJson(
        CommentReportResponseModel instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'reason': instance.reason,
      'reporterId': instance.reporterId,
      'createdAt': instance.createdAt,
    };
