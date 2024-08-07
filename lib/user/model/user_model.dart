import 'package:swm_kkokkomu_frontend/common/const/data.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModel extends UserModelBase {}

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
