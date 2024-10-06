import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';

part 'hided_user_model.g.dart';

sealed class HidedUserModelBase {}

class HidedUserModelLoading extends HidedUserModelBase {}

class HidedUserModelError extends HidedUserModelBase {
  final String message;

  HidedUserModelError({
    required this.message,
  }) {
    debugPrint('HidedUserModelError: $message');
  }
}

class HidedUserModel extends HidedUserModelBase {
  final List<HidedUserData> hidedUserList;

  HidedUserModel({
    required this.hidedUserList,
  });
}

@JsonSerializable()
class HidedUserData {
  final int id;
  final String userName;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime createdAt;

  HidedUserData({
    int? id,
    String? userName,
    required this.createdAt,
  })  : id = id ?? Constants.unknownErrorId,
        userName = userName ?? Constants.unknownErrorString;

  factory HidedUserData.fromJson(Map<String, dynamic> json) =>
      _$HidedUserDataFromJson(json);
}
