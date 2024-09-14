// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_shortform_additional_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExploreShortFormAdditionalParams _$ExploreShortFormAdditionalParamsFromJson(
        Map<String, dynamic> json) =>
    ExploreShortFormAdditionalParams(
      category:
          $enumDecode(_$NewsCategoryInExplorationEnumMap, json['category']),
    );

Map<String, dynamic> _$ExploreShortFormAdditionalParamsToJson(
        ExploreShortFormAdditionalParams instance) =>
    <String, dynamic>{
      'category': _$NewsCategoryInExplorationEnumMap[instance.category]!,
    };

const _$NewsCategoryInExplorationEnumMap = {
  NewsCategoryInExploration.popular: 'popular',
  NewsCategoryInExploration.politics: 'politics',
  NewsCategoryInExploration.economy: 'economy',
  NewsCategoryInExploration.social: 'social',
  NewsCategoryInExploration.entertain: 'entertain',
  NewsCategoryInExploration.sports: 'sports',
  NewsCategoryInExploration.living: 'living',
  NewsCategoryInExploration.world: 'world',
  NewsCategoryInExploration.it: 'it',
};
