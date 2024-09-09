// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_post_reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PutPostReactionModel _$PutPostReactionModelFromJson(
        Map<String, dynamic> json) =>
    PutPostReactionModel(
      newsId: (json['newsId'] as num).toInt(),
      reaction: $enumDecode(_$ReactionTypeEnumMap, json['reaction']),
    );

Map<String, dynamic> _$PutPostReactionModelToJson(
        PutPostReactionModel instance) =>
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

PutPostReactionResponseModel _$PutPostReactionResponseModelFromJson(
        Map<String, dynamic> json) =>
    PutPostReactionResponseModel(
      userId: (json['userId'] as num?)?.toInt(),
      newsId: (json['newsId'] as num?)?.toInt(),
      reaction: $enumDecodeNullable(_$ReactionTypeEnumMap, json['reaction']),
    );

Map<String, dynamic> _$PutPostReactionResponseModelToJson(
        PutPostReactionResponseModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'newsId': instance.newsId,
      'reaction': _$ReactionTypeEnumMap[instance.reaction],
    };
