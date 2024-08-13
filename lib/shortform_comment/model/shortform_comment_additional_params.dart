import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'shortform_comment_additional_params.g.dart';

@JsonSerializable()
class ShortFormCommentAdditionalParams extends AdditionalParams {
  final int newsId;

  ShortFormCommentAdditionalParams({
    required this.newsId,
  });

  @override
  Map<String, dynamic> toJson() =>
      _$ShortFormCommentAdditionalParamsToJson(this);
}
