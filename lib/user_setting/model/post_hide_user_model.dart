import 'package:json_annotation/json_annotation.dart';

part 'post_hide_user_model.g.dart';

@JsonSerializable()
class PostHideUserModel {
  final int hidedUserId;

  PostHideUserModel({
    required this.hidedUserId,
  });

  Map<String, dynamic> toJson() => _$PostHideUserModelToJson(this);
}
