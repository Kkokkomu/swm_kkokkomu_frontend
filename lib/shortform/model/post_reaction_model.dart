import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'post_reaction_model.g.dart';

@JsonSerializable()
class PostReactionModel {
  final int newsId;
  final ReactionType reaction;

  PostReactionModel({
    required this.newsId,
    required this.reaction,
  });

  Map<String, dynamic> toJson() => _$PostReactionModelToJson(this);
}

@JsonSerializable()
class PostReactionResponseModel {
  final int userId;
  final int newsId;
  final ReactionType? reaction;

  PostReactionResponseModel({
    int? userId,
    int? newsId,
    this.reaction,
  })  : userId = userId ?? Constants.unknownErrorId,
        newsId = newsId ?? Constants.unknownErrorId;

  factory PostReactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostReactionResponseModelFromJson(json);
}
