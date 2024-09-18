// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_shortform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationShortFormModel _$PaginationShortFormModelFromJson(
        Map<String, dynamic> json) =>
    PaginationShortFormModel(
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

Map<String, dynamic> _$PaginationShortFormModelToJson(
        PaginationShortFormModel instance) =>
    <String, dynamic>{
      'info': instance.info,
      'reactionCnt': instance.reactionCnt,
      'userReaction': instance.userReaction,
    };
