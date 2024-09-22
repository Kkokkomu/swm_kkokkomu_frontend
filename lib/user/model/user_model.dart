// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  }) {
    debugPrint('UserModelError: $message');
  }
}

class InitialUserModel extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final int id;
  final String nickname;
  final String email;
  final bool isPremium;
  final String premiumEndDate;
  final String? profileImg;

  UserModel({
    required int? id,
    required String? nickname,
    required String? email,
    required bool? isPremium,
    required String? premiumEndDate,
    required String? profileImg,
  })  : id = id ?? Constants.unknownErrorId,
        nickname = nickname ?? Constants.unknownErrorString,
        email = email ?? Constants.unknownErrorString,
        isPremium = isPremium ?? false,
        premiumEndDate = premiumEndDate ?? Constants.unknownErrorString,
        profileImg = profileImg ?? Constants.defaultProfileImageUrl {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (id == null ||
        nickname == null ||
        email == null ||
        isPremium == null ||
        premiumEndDate == null ||
        profileImg == null) {
      debugPrint('[Null Detected] UserModel: Null value detected');
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserModel copyWith({
    int? id,
    String? nickname,
    String? email,
    bool? isPremium,
    String? premiumEndDate,
    String? profileImg,
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      premiumEndDate: premiumEndDate ?? this.premiumEndDate,
      profileImg: profileImg ?? this.profileImg,
    );
  }
}

class UnregisteredUserModel extends UserModelBase {
  final SocialLoginType socialLoginType;
  final String accessToken;

  UnregisteredUserModel({
    required this.socialLoginType,
    required this.accessToken,
  });
}

class GuestUserModel extends UserModelBase {
  final String deviceId;

  GuestUserModel({
    required this.deviceId,
  });
}
