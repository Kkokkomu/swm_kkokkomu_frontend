import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

part 'hided_user_model.g.dart';

@JsonSerializable()
class HidedUserModel {
  final int id;
  final String userName;
  final String createdAt;

  HidedUserModel({
    required int? id,
    required String? userName,
    required String? createdAt,
  })  : id = id ?? Constants.unknownErrorId,
        userName = userName ?? 'N/A',
        createdAt = createdAt ?? 'N/A';

  factory HidedUserModel.fromJson(Map<String, dynamic> json) =>
      _$HidedUserModelFromJson(json);
}
