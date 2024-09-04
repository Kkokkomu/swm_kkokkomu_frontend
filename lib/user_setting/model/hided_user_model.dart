import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

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
  final String createdAt;

  HidedUserData({
    required int? id,
    required String? userName,
    required String? createdAt,
  })  : id = id ?? Constants.unknownErrorId,
        userName = userName ?? 'N/A',
        createdAt = createdAt ?? 'N/A';

  factory HidedUserData.fromJson(Map<String, dynamic> json) =>
      _$HidedUserDataFromJson(json);
}
