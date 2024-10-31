import 'package:json_annotation/json_annotation.dart';

part 'post_update_fcm_token_body.g.dart';

@JsonSerializable()
class PostUpdateFcmTokenBody {
  final String fcmToken;

  PostUpdateFcmTokenBody({
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => _$PostUpdateFcmTokenBodyToJson(this);
}
