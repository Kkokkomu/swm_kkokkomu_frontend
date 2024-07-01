import 'package:json_annotation/json_annotation.dart';

part 'post_login_body.g.dart';

@JsonSerializable()
class PostLoginBody {
  final String uuid;

  PostLoginBody({required this.uuid});

  factory PostLoginBody.fromJson(Map<String, dynamic> json) =>
      _$PostLoginBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostLoginBodyToJson(this);
}
