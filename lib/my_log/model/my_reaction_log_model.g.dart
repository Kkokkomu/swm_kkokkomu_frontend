// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_reaction_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyReactionLogModel _$MyReactionLogModelFromJson(Map<String, dynamic> json) =>
    MyReactionLogModel(
      info: json['info'] == null
          ? null
          : ShortFormInfo.fromJson(json['info'] as Map<String, dynamic>),
      reactionCnt: json['reactionCnt'] == null
          ? null
          : ShortFormReactionCountInfo.fromJson(
              json['reactionCnt'] as Map<String, dynamic>),
      userReaction: json['userReaction'] == null
          ? null
          : ShortFormUserReactionInfo.fromJson(
              json['userReaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyReactionLogModelToJson(MyReactionLogModel instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reactionCnt': instance.reactionCnt,
      'userReaction': instance.userReaction,
    };
