import 'package:json_annotation/json_annotation.dart';

part 'shortform_model.g.dart';

@JsonSerializable()
class ShortFormModel {
  final ShortFormUrlInfo? shortformList;
  final ShortFormReactionCountInfo reactionCnt;
  final ShortFormUserReactionInfo userReaction;

  ShortFormModel({
    this.shortformList,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  })  : reactionCnt = reactionCnt ?? ShortFormReactionCountInfo(),
        userReaction = userReaction ?? ShortFormUserReactionInfo();

  factory ShortFormModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormModelFromJson(json);
}

@JsonSerializable()
class ShortFormUrlInfo {
  final int? id;
  final String? shortformUrl;

  ShortFormUrlInfo({
    this.id,
    this.shortformUrl,
  });

  factory ShortFormUrlInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormUrlInfoFromJson(json);
}

@JsonSerializable()
class ShortFormReactionCountInfo {
  final int like;
  final int surprise;
  final int sad;
  final int angry;

  ShortFormReactionCountInfo({
    int? like,
    int? surprise,
    int? sad,
    int? angry,
  })  : like = like ?? 0,
        surprise = surprise ?? 0,
        sad = sad ?? 0,
        angry = angry ?? 0;

  factory ShortFormReactionCountInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormReactionCountInfoFromJson(json);
}

@JsonSerializable()
class ShortFormUserReactionInfo {
  final bool like;
  final bool surprise;
  final bool sad;
  final bool angry;

  ShortFormUserReactionInfo({
    bool? like,
    bool? surprise,
    bool? sad,
    bool? angry,
  })  : like = like ?? false,
        surprise = surprise ?? false,
        sad = sad ?? false,
        angry = angry ?? false;

  factory ShortFormUserReactionInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormUserReactionInfoFromJson(json);
}
