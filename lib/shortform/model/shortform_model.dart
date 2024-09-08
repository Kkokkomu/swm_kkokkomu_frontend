// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

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

  ShortFormModel copyWith({
    ShortFormUrlInfo? shortformList,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  }) {
    return ShortFormModel(
      shortformList: shortformList ?? this.shortformList,
      reactionCnt: reactionCnt ?? this.reactionCnt,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}

@JsonSerializable()
class ShortFormUrlInfo {
  final int? id;
  final String? shortformUrl;
  final String relatedUrl;

  ShortFormUrlInfo({
    this.id,
    this.shortformUrl,
    String? relatedUrl,
  }) : relatedUrl = relatedUrl ?? Constants.relatedUrlOnError;

  factory ShortFormUrlInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormUrlInfoFromJson(json);
}

@JsonSerializable()
class ShortFormReactionCountInfo {
  final int total;
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
        angry = angry ?? 0,
        total = (like ?? 0) + (surprise ?? 0) + (sad ?? 0) + (angry ?? 0);

  factory ShortFormReactionCountInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormReactionCountInfoFromJson(json);

  ShortFormReactionCountInfo copyWith({
    int? like,
    int? surprise,
    int? sad,
    int? angry,
  }) {
    return ShortFormReactionCountInfo(
      like: like ?? this.like,
      surprise: surprise ?? this.surprise,
      sad: sad ?? this.sad,
      angry: angry ?? this.angry,
    );
  }

  int getReactionCountByType(ReactionType reactionType) {
    return switch (reactionType) {
      ReactionType.like => like,
      ReactionType.surprise => surprise,
      ReactionType.sad => sad,
      ReactionType.angry => angry
    };
  }
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

  ShortFormUserReactionInfo.createByReactionType(ReactionType reactionType)
      : like = reactionType == ReactionType.like,
        surprise = reactionType == ReactionType.surprise,
        sad = reactionType == ReactionType.sad,
        angry = reactionType == ReactionType.angry;

  ReactionType? getReactionType() {
    if (like) return ReactionType.like;
    if (surprise) return ReactionType.surprise;
    if (sad) return ReactionType.sad;
    if (angry) return ReactionType.angry;

    return null;
  }
}
