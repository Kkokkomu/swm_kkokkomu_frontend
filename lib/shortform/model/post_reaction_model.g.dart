// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReactionModel _$PostReactionModelFromJson(Map<String, dynamic> json) =>
    PostReactionModel(
      newsId: (json['newsId'] as num).toInt(),
      reaction: $enumDecode(_$ReactionTypeEnumMap, json['reaction']),
    );

Map<String, dynamic> _$PostReactionModelToJson(PostReactionModel instance) =>
    <String, dynamic>{
      'newsId': instance.newsId,
      'reaction': _$ReactionTypeEnumMap[instance.reaction]!,
    };

const _$ReactionTypeEnumMap = {
  ReactionType.like: 'LIKE',
  ReactionType.angry: 'ANGRY',
  ReactionType.surprise: 'SURPRISE',
  ReactionType.sad: 'SAD',
};

PostReactionResponseModel _$PostReactionResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostReactionResponseModel(
      userId: (json['userId'] as num?)?.toInt(),
      newsId: (json['newsId'] as num?)?.toInt(),
      reaction: $enumDecodeNullable(_$ReactionTypeEnumMap, json['reaction']),
    );

Map<String, dynamic> _$PostReactionResponseModelToJson(
        PostReactionResponseModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'newsId': instance.newsId,
      'reaction': _$ReactionTypeEnumMap[instance.reaction],
    };
