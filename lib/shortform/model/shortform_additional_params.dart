import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'shortform_additional_params.g.dart';

@JsonSerializable()
class ShortFormAdditionalParams extends AdditionalParams {
  final String category;
  final ShortFormSortType filter;

  ShortFormAdditionalParams({
    required this.category,
    required this.filter,
  });

  @override
  Map<String, dynamic> toJson() => _$ShortFormAdditionalParamsToJson(this);
}
