// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
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
        userLike = userLike ?? false {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (user == null ||
        comment == null ||
        replyCnt == null ||
        commentLikeCnt == null ||
        userLike == null) {
      debugPrint('[Null Detected] ShortFormCommentModel: Null value detected');
    }
  }

  factory ShortFormCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormCommentModelFromJson(json);

  ShortFormCommentModel copyWith({
    ShortFormCommentUserInfo? user,
    ShortFormCommentInfo? comment,
    int? replyCnt,
    int? commentLikeCnt,
    bool? userLike,
  }) {
    return ShortFormCommentModel(
      user: user ?? this.user,
      comment: comment ?? this.comment,
      replyCnt: replyCnt ?? this.replyCnt,
      commentLikeCnt: commentLikeCnt ?? this.commentLikeCnt,
      userLike: userLike ?? this.userLike,
    );
  }
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
        nickname = nickname ?? 'N/A' {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (id == null || profileImg == null || nickname == null) {
      debugPrint(
          '[Null Detected] ShortFormCommentUserInfo: Null value detected');
    }
  }

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
        editedAt = editedAt ?? '1900-01-01' {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (id == null ||
        userId == null ||
        newsId == null ||
        content == null ||
        editedAt == null) {
      debugPrint('[Null Detected] ShortFormCommentInfo: Null value detected');
    }
  }

  factory ShortFormCommentInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormCommentInfoFromJson(json);

  ShortFormCommentInfo copyWith({
    int? id,
    int? userId,
    int? newsId,
    String? content,
    String? editedAt,
  }) {
    return ShortFormCommentInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      newsId: newsId ?? this.newsId,
      content: content ?? this.content,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}
