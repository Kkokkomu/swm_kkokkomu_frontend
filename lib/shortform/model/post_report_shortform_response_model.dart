import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'post_report_shortform_response_model.g.dart';

@JsonSerializable()
class PostReportShortformResponseModel {
  final int reportId;
  final ShortFormReportType reason;
  final int reporterId;
  final String createdAt;

  PostReportShortformResponseModel({
    int? reportId,
    ShortFormReportType? reason,
    int? reporterId,
    String? createdAt,
  })  : reportId = reportId ?? Constants.unknownErrorId,
        reason = reason ?? ShortFormReportType.spam,
        reporterId = reporterId ?? Constants.unknownErrorId,
        createdAt = createdAt ?? Constants.unknownErrorString;

  factory PostReportShortformResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$PostReportShortformResponseModelFromJson(json);
}
