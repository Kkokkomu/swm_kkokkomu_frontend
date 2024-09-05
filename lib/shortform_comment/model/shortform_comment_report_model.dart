import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'shortform_comment_report_model.g.dart';

@JsonSerializable()
class PostCommentReportModel {
  final CommentReportType reason;
  final int commentId;

  PostCommentReportModel({
    required this.reason,
    required this.commentId,
  });

  Map<String, dynamic> toJson() => _$PostCommentReportModelToJson(this);
}

@JsonSerializable()
class CommentReportResponseModel {
  final int reportId;
  final String reason;
  final int reporterId;
  final String createdAt;

  CommentReportResponseModel({
    int? reportId,
    String? reason,
    int? reporterId,
    String? createdAt,
  })  : reportId = reportId ?? Constants.unknownErrorId,
        reason = reason ?? Constants.unknownErrorString,
        reporterId = reporterId ?? Constants.unknownErrorId,
        createdAt = createdAt ?? Constants.unknownErrorString;

  factory CommentReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentReportResponseModelFromJson(json);
}
