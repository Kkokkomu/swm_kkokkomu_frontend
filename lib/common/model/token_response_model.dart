import 'package:json_annotation/json_annotation.dart';

part 'token_response_model.g.dart';

@JsonSerializable()
class TokenResponseModel {
  final String? accessToken;
  final String? refreshToken;

  TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseModelFromJson(json);
}
