import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'post_register_body.g.dart';

@JsonSerializable(includeIfNull: false)
class PostRegisterBody {
  final String provider;
  final String nickname;
  final GenderType sex;
  final String birthday;
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
