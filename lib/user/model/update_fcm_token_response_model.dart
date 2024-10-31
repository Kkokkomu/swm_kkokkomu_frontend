import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';

part 'update_fcm_token_response_model.g.dart';

@JsonSerializable()
class UpdateFcmTokenResponseModel {
  final int id;
  final String token;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime editedAt;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime expiredAt;

  UpdateFcmTokenResponseModel({
    int? id,
    String? token,
    required this.editedAt,
    required this.expiredAt,
  })  : id = id ?? Constants.unknownErrorId,
        token = token ?? Constants.unknownErrorString;

  factory UpdateFcmTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateFcmTokenResponseModelFromJson(json);
}
