import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'pagination_shortform_model.g.dart';

@JsonSerializable()
class PaginationShortFormModel implements IModelWithId {
  @override
  final int id;
  final ShortFormInfo info;
  final ShortFormReactionCountInfo reactionCnt;
  final ShortFormUserReactionInfo userReaction;

  PaginationShortFormModel({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  })  : info = info ?? ShortFormInfo(),
        reactionCnt = reactionCnt ?? ShortFormReactionCountInfo(),
        userReaction = userReaction ?? ShortFormUserReactionInfo(),
        id = info?.news.id ?? Constants.unknownErrorId;

  factory PaginationShortFormModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationShortFormModelFromJson(json);
}
