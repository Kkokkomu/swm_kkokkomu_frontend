import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'put_user_profile_body.g.dart';

@JsonSerializable()
class PutUserProfileBody {
  final String nickname;
  final String birthday;
  final GenderType sex;

  PutUserProfileBody({
    required this.nickname,
    required this.birthday,
    required this.sex,
  });

  Map<String, dynamic> toJson() => _$PutUserProfileBodyToJson(this);
}
