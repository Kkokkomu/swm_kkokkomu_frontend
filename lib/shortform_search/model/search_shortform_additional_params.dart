import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'search_shortform_additional_params.g.dart';

@JsonSerializable()
class SearchShortFormAdditionalParams extends AdditionalParams {
  final String text;
  final String category;
  final ShortFormSortType filter;

  SearchShortFormAdditionalParams({
    required this.text,
    required this.category,
    required this.filter,
  });

  @override
  Map<String, dynamic> toJson() =>
      _$SearchShortFormAdditionalParamsToJson(this);
}
