import 'package:json_annotation/json_annotation.dart';

part 'put_shortform_comment_model.g.dart';

@JsonSerializable()
class PutShortFormCommentBody {
  final int commentId;
  final String content;

  PutShortFormCommentBody({
    required this.commentId,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$PutShortFormCommentBodyToJson(this);
}
