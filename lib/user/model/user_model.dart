import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String nickname;
  final String email;
  final bool isPremium;
  final String premiumEndDate;
  final String profileImg;

  UserModel({
    required String? nickname,
    required String? email,
    required bool? isPremium,
    required String? premiumEndDate,
    required String? profileImg,
  })  : nickname = nickname ?? 'N/A',
        email = email ?? 'N/A',
        isPremium = isPremium ?? false,
        premiumEndDate = premiumEndDate ?? 'N/A',
        profileImg = profileImg ?? '';
  // TODO : 기본 프로필 이미지 경로 추가

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
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
  final String guestUserId;

  GuestUserModel({
    required this.guestUserId,
  });
}
