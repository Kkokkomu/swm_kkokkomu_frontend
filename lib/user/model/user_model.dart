abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModel extends UserModelBase {
  final String id;

  UserModel({
    required this.id,
  });
}
