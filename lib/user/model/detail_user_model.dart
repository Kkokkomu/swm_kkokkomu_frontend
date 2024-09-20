import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'detail_user_model.g.dart';

sealed class DetailUserModelBase {}

class DetailUserModelLoading extends DetailUserModelBase {}

class DetailUserModelError extends DetailUserModelBase {
  final String message;

  DetailUserModelError(this.message);
}

@JsonSerializable()
class DetailUserModel extends DetailUserModelBase {
  final int id;
  final String? profileUrl;
  final String nickname;
  final String email;
  final GenderType sex;
  final String birthday;
  final String createdAt;
  final String editedAt;
  final String profileEditedAt;

  DetailUserModel({
    int? id,
    String? profileUrl,
    String? nickname,
    String? email,
    GenderType? sex,
    String? birthday,
    String? createdAt,
    String? editedAt,
    String? profileEditedAt,
  })  : id = id ?? Constants.unknownErrorId,
        profileUrl = profileUrl ?? Constants.defaultProfileImageUrl,
        nickname = nickname ?? Constants.unknownErrorString,
        email = email ?? Constants.unknownErrorString,
        sex = sex ?? GenderType.none,
        birthday = birthday ?? Constants.unknownErrorString,
        createdAt = createdAt ?? Constants.unknownErrorString,
        editedAt = editedAt ?? Constants.unknownErrorString,
        profileEditedAt =
            profileEditedAt ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory DetailUserModel.fromJson(Map<String, dynamic> json) =>
      _$DetailUserModelFromJson(json);
}
