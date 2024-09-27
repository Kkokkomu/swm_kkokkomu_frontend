import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';

part 'put_user_profile_body.g.dart';

@JsonSerializable()
class PutUserProfileBody {
  final String nickname;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime birthday;
  final GenderType sex;

  PutUserProfileBody({
    required this.nickname,
    required this.birthday,
    required this.sex,
  });

  Map<String, dynamic> toJson() => _$PutUserProfileBodyToJson(this);
}
