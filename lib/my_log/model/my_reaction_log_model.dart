import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_model_with_id_and_url.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'my_reaction_log_model.g.dart';

@JsonSerializable()
class MyReactionLogModel implements IShortFormModelWithIdAndNewsIdAndUrl {
  @override
  final int id;
  @override
  final int newsId;
  @override
  final String? shortFormUrl;
  final ShortFormInfo info;
  final ShortFormReactionCountInfo reactionCnt;
  final ShortFormUserReactionInfo userReaction;

  MyReactionLogModel({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  })  : info = info ?? ShortFormInfo(),
        reactionCnt = reactionCnt ?? ShortFormReactionCountInfo(),
        userReaction = userReaction ?? ShortFormUserReactionInfo(),
        id = userReaction?.id ?? Constants.unknownErrorId,
        newsId = info?.news.id ?? Constants.unknownErrorId,
        shortFormUrl = info?.news.shortformUrl;

  factory MyReactionLogModel.fromJson(Map<String, dynamic> json) =>
      _$MyReactionLogModelFromJson(json);

  MyReactionLogModel copyWith({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  }) {
    return MyReactionLogModel(
      info: info ?? this.info,
      reactionCnt: reactionCnt ?? this.reactionCnt,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}
