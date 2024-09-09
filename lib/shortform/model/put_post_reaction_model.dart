import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'put_post_reaction_model.g.dart';

@JsonSerializable()
class PutPostReactionModel {
  final int newsId;
  final ReactionType reaction;

  PutPostReactionModel({
    required this.newsId,
    required this.reaction,
  });

  Map<String, dynamic> toJson() => _$PutPostReactionModelToJson(this);
}

@JsonSerializable()
class PutPostReactionResponseModel {
  final int userId;
  final int newsId;
  final ReactionType? reaction;

  PutPostReactionResponseModel({
    int? userId,
    int? newsId,
    this.reaction,
  })  : userId = userId ?? Constants.unknownErrorId,
        newsId = newsId ?? Constants.unknownErrorId;

  factory PutPostReactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PutPostReactionResponseModelFromJson(json);
}
