import 'package:json_annotation/json_annotation.dart';

part 'post_register_body.g.dart';

@JsonSerializable(includeIfNull: false)
class PostRegisterBody {
  final String provider;
  final String nickname;
  final String sex;
  final String birthday;
  final String? recommandCode;

  PostRegisterBody({
    required this.provider,
    required this.nickname,
    required this.sex,
    required this.birthday,
    this.recommandCode,
  });

  Map<String, dynamic> toJson() => _$PostRegisterBodyToJson(this);
}
