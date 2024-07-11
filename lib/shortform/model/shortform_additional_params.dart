import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'shortform_additional_params.g.dart';

@JsonSerializable()
class ShortFormAdditionalParams extends AdditionalParams {
  final String userId;

  ShortFormAdditionalParams({
    required this.userId,
  });

  factory ShortFormAdditionalParams.fromJson(Map<String, dynamic> json) =>
      _$ShortFormAdditionalParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShortFormAdditionalParamsToJson(this);
}
