import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

part 'shortform_reply_model.g.dart';

@JsonSerializable()
class ShortFormReplyInfo {
  final int id;
  final int userId;
  final int newsId;
  final int parentId;
  final String content;
  final String editedAt;

  ShortFormReplyInfo({
    int? id,
    int? userId,
    int? newsId,
    int? parentId,
    String? content,
    String? editedAt,
  })  : id = id ?? Constants.unknownErrorId,
        userId = userId ?? Constants.unknownErrorId,
        newsId = newsId ?? Constants.unknownErrorId,
        parentId = parentId ?? Constants.unknownErrorId,
        content = content ?? '',
        editedAt = editedAt ?? Constants.unknownErrorString {
    // 널값이 하나라도 들어오면 기본값으로 설정하고 로그를 남김
    if (id == null ||
        userId == null ||
        newsId == null ||
        parentId == null ||
        content == null ||
        editedAt == null) {
      debugPrint('[Null Detected] ShortFormReplyInfo: Null value detected');
    }
  }

  factory ShortFormReplyInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormReplyInfoFromJson(json);

  ShortFormReplyInfo copyWith({
    int? id,
    int? userId,
    int? newsId,
    int? parentId,
    String? content,
    String? editedAt,
  }) {
    return ShortFormReplyInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      newsId: newsId ?? this.newsId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}
