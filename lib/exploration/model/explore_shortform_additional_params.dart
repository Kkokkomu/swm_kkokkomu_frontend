import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'explore_shortform_additional_params.g.dart';

@JsonSerializable()
class ExploreShortFormAdditionalParams extends AdditionalParams {
  final NewsCategoryInExploration category;

  ExploreShortFormAdditionalParams({
    required this.category,
  });

  @override
  Map<String, dynamic> toJson() =>
      _$ExploreShortFormAdditionalParamsToJson(this);
}
