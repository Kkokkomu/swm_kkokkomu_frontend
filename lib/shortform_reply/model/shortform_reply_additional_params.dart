import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'shortform_reply_additional_params.g.dart';

@JsonSerializable()
class ShortFormReplyAdditionalParams extends AdditionalParams {
  final int commentId;

  ShortFormReplyAdditionalParams({
    required this.commentId,
  });

  @override
  Map<String, dynamic> toJson() => _$ShortFormReplyAdditionalParamsToJson(this);
}
