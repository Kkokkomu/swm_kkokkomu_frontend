import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
import 'package:swm_kkokkomu_frontend/common/utils/custom_date_utils.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

part 'my_comment_log_model.g.dart';

@JsonSerializable()
class MyCommentLogModel implements IModelWithId {
  @override
  final int id;
  final MyCommentLogInfo comment;
  final MyCommentLogShortFormInfo news;

  MyCommentLogModel({
    MyCommentLogInfo? comment,
    MyCommentLogShortFormInfo? news,
  })  : comment = comment ??
            MyCommentLogInfo(
              editedAt: DateTime(Constants.unknownErrorDateTimeYear),
              parentId: null,
            ),
        news = news ?? MyCommentLogShortFormInfo(),
        id = comment?.id ?? Constants.unknownErrorId;

  factory MyCommentLogModel.fromJson(Map<String, dynamic> json) =>
      _$MyCommentLogModelFromJson(json);

  MyCommentLogModel copyWith({
    MyCommentLogInfo? comment,
    MyCommentLogShortFormInfo? news,
  }) {
    return MyCommentLogModel(
      comment: comment ?? this.comment,
      news: news ?? this.news,
    );
  }
}

@JsonSerializable()
class MyCommentLogInfo {
  final int id;
  final int userId;
  final int newsId;
  final String content;
  @JsonKey(
    fromJson: CustomDateUtils.parseDateTime,
    toJson: CustomDateUtils.formatDateTime,
  )
  final DateTime editedAt;
  final int? parentId;

  MyCommentLogInfo({
    int? id,
    int? userId,
    int? newsId,
    String? content,
    required this.editedAt,
    required this.parentId,
  })  : id = id ?? Constants.unknownErrorId,
        userId = userId ?? Constants.unknownErrorId,
        newsId = newsId ?? Constants.unknownErrorId,
        content = content ?? '' {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (id == null || userId == null || newsId == null || content == null) {
      debugPrint('[Null Detected] MyCommentLogInfo: Null value detected');
    }
  }

  factory MyCommentLogInfo.fromJson(Map<String, dynamic> json) =>
      _$MyCommentLogInfoFromJson(json);

  MyCommentLogInfo copyWith({
    int? id,
    int? userId,
    int? newsId,
    String? content,
    DateTime? editedAt,
    int? parentId,
  }) {
    return MyCommentLogInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      newsId: newsId ?? this.newsId,
      content: content ?? this.content,
      editedAt: editedAt ?? this.editedAt,
      parentId: parentId ?? this.parentId,
    );
  }
}

@JsonSerializable()
class MyCommentLogShortFormInfo {
  final ShortFormInfo info;
  final ShortFormReactionCountInfo reactionCnt;
  final ShortFormUserReactionInfo userReaction;

  MyCommentLogShortFormInfo({
    ShortFormInfo? info,
    ShortFormReactionCountInfo? reactionCnt,
    ShortFormUserReactionInfo? userReaction,
  })  : info = info ?? ShortFormInfo(),
        reactionCnt = reactionCnt ?? ShortFormReactionCountInfo(),
        userReaction = userReaction ?? ShortFormUserReactionInfo();

  factory MyCommentLogShortFormInfo.fromJson(Map<String, dynamic> json) =>
      _$MyCommentLogShortFormInfoFromJson(json);
}
