import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';

part 'shortform_comment_model.g.dart';

@JsonSerializable()
class ShortFormCommentModel implements IModelWithId {
  @override
  final int id;
  final ShortFormCommentUserInfo user;
  final ShortFormCommentInfo comment;
  final int replyCnt;
  final int commentLikeCnt;
  final bool userLike;

  ShortFormCommentModel({
    ShortFormCommentUserInfo? user,
    ShortFormCommentInfo? comment,
    int? replyCnt,
    int? commentLikeCnt,
    bool? userLike,
  })  : user = user ?? ShortFormCommentUserInfo(),
        comment = comment ?? ShortFormCommentInfo(),
        replyCnt = replyCnt ?? 0,
        commentLikeCnt = commentLikeCnt ?? 0,
        id = comment?.id ?? Constants.unknownErrorId,
        userLike = userLike ?? false;

  factory ShortFormCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormCommentModelFromJson(json);
}

@JsonSerializable()
class ShortFormCommentUserInfo {
  final int id;
  final String? profileImg;
  final String nickname;

  ShortFormCommentUserInfo({
    int? id,
    String? profileImg,
    String? nickname,
  })  : id = id ?? Constants.unknownErrorId,
        profileImg = profileImg ?? Constants.defaultProfileImageUrl,
        nickname = nickname ?? 'N/A';

  factory ShortFormCommentUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormCommentUserInfoFromJson(json);
}

@JsonSerializable()
class ShortFormCommentInfo {
  final int id;
  final int userId;
  final int newsId;
  final String content;
  final String editedAt;

  ShortFormCommentInfo({
    int? id,
    int? userId,
    int? newsId,
    String? content,
    String? editedAt,
  })  : id = id ?? Constants.unknownErrorId,
        userId = userId ?? Constants.unknownErrorId,
        newsId = newsId ?? Constants.unknownErrorId,
        content = content ?? '',
        editedAt = editedAt ?? '1900-01-01';

  factory ShortFormCommentInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormCommentInfoFromJson(json);
}
