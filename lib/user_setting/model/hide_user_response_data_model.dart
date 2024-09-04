import 'package:json_annotation/json_annotation.dart';

part 'hide_user_response_data_model.g.dart';

@JsonSerializable()
class HideUserResponseDataModel {
  final int? reporterId;
  final int? hidedUserId;

  HideUserResponseDataModel({
    required this.reporterId,
    required this.hidedUserId,
  });

  factory HideUserResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$HideUserResponseDataModelFromJson(json);
}
