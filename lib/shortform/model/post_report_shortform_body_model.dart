import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'post_report_shortform_body_model.g.dart';

@JsonSerializable()
class PostReportShortFormBodyModel {
  final ShortFormReportType reason;
  final int newsId;

  PostReportShortFormBodyModel({
    required this.reason,
    required this.newsId,
  });

  Map<String, dynamic> toJson() => _$PostReportShortFormBodyModelToJson(this);
}
