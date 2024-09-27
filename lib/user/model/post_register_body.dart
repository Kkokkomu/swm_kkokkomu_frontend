import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';

part 'post_register_body.g.dart';

@JsonSerializable(includeIfNull: false)
class PostRegisterBody {
  final String provider;
  final String nickname;
  final GenderType sex;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime birthday;
  final String? recommendCode;

  PostRegisterBody({
    required this.provider,
    required this.nickname,
    required this.sex,
    required this.birthday,
    this.recommendCode,
  });

  Map<String, dynamic> toJson() => _$PostRegisterBodyToJson(this);
}
