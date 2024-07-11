import 'package:json_annotation/json_annotation.dart';

part 'shortform_model.g.dart';

@JsonSerializable()
class ShortFormModel {
  final ShortFormUrlInfo? shortForm;
  final ShortFormReactionInfo? reaction;
  final ShortFormReactionWithUserInfo? reactionWithUser;

  ShortFormModel({
    required this.shortForm,
    required this.reaction,
    required this.reactionWithUser,
  });

  factory ShortFormModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormModelFromJson(json);
}

@JsonSerializable()
class ShortFormUrlInfo {
  final int? id;
  final String? shortformUrl;
  final String? youtubeUrl;
  final String? instagramUrl;
  final String? relatedUrl;

  ShortFormUrlInfo({
    required this.id,
    required this.shortformUrl,
    required this.youtubeUrl,
    required this.instagramUrl,
    required this.relatedUrl,
  });

  factory ShortFormUrlInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormUrlInfoFromJson(json);
}

@JsonSerializable()
class ShortFormReactionInfo {
  final int? great;
  final int? hate;
  final int? expect;
  final int? surprise;

  ShortFormReactionInfo({
    required this.great,
    required this.hate,
    required this.expect,
    required this.surprise,
  });

  factory ShortFormReactionInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormReactionInfoFromJson(json);
}

@JsonSerializable()
class ShortFormReactionWithUserInfo {
  final bool great;
  final bool hate;
  final bool expect;
  final bool surprise;

  ShortFormReactionWithUserInfo({
    required this.great,
    required this.hate,
    required this.expect,
    required this.surprise,
  });

  factory ShortFormReactionWithUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormReactionWithUserInfoFromJson(json);
}
