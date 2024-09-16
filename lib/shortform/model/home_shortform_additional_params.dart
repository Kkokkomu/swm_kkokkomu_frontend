import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';

part 'home_shortform_additional_params.g.dart';

@JsonSerializable()
class HomeShortFormAdditionalParams extends AdditionalParams {
  final ShortFormSortType filter;

  HomeShortFormAdditionalParams({
    required this.filter,
  });

  @override
  Map<String, dynamic> toJson() => _$HomeShortFormAdditionalParamsToJson(this);
}
