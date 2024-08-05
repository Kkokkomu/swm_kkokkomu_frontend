abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModel extends UserModelBase {
  final String id;

  UserModel({
    required this.id,
  });
}

class GuestUserModel extends UserModelBase {
  final String id;

  GuestUserModel({
    required this.id,
  });
}
