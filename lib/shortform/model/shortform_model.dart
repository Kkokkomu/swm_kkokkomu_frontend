// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'shortform_model.g.dart';

@JsonSerializable()
class ShortFormModel {
  final ShortFormInfo info;
  final ShortFormReactionCountInfo reactionCnt;
  final ShortFormUserReactionInfo userReaction;

  ShortFormModel({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  })  : info = info ?? ShortFormInfo(),
        reactionCnt = reactionCnt ?? ShortFormReactionCountInfo(),
        userReaction = userReaction ?? ShortFormUserReactionInfo();

  factory ShortFormModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormModelFromJson(json);

  ShortFormModel copyWith({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  }) {
    return ShortFormModel(
      info: info ?? this.info,
      reactionCnt: reactionCnt ?? this.reactionCnt,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}

@JsonSerializable()
class ShortFormInfo {
  ShortFormNewsInfo news;
  List<String> keywords;

  ShortFormInfo({
    ShortFormNewsInfo? news,
    List<String>? keywords,
  })  : news = news ?? ShortFormNewsInfo(),
        keywords = keywords ?? [];

  factory ShortFormInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormInfoFromJson(json);
}

@JsonSerializable()
class ShortFormNewsInfo {
  int? id;
  String? shortformUrl;
  String? youtubeUrl;
  String? instagramUrl;
  String relatedUrl;
  String? thumbnail;
  int viewCnt;
  String title;
  String summary;
  int sharedCnt;
  NewsCategory category;
  String createdAt;
  String editedAt;

  ShortFormNewsInfo({
    this.id,
    this.shortformUrl,
    this.youtubeUrl,
    this.instagramUrl,
    String? relatedUrl,
    this.thumbnail,
    int? viewCnt,
    String? title,
    String? summary,
    int? sharedCnt,
    NewsCategory? category,
    String? createdAt,
    String? editedAt,
  })  : relatedUrl = relatedUrl ?? Constants.relatedUrlOnError,
        viewCnt = viewCnt ?? 0,
        title = title ?? Constants.unknownErrorString,
        summary = summary ?? Constants.unknownErrorString,
        sharedCnt = sharedCnt ?? 0,
        category = category ?? NewsCategory.social,
        createdAt = createdAt ?? Constants.unknownErrorString,
        editedAt = editedAt ?? Constants.unknownErrorString;

  factory ShortFormNewsInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormNewsInfoFromJson(json);
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
