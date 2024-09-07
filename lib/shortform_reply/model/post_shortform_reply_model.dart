import 'package:json_annotation/json_annotation.dart';

part 'post_shortform_reply_model.g.dart';

@JsonSerializable()
class PostShortFormReplyBody {
  final int newsId;
  final int commentId;
  final String content;

  PostShortFormReplyBody({
    required this.newsId,
    required this.commentId,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$PostShortFormReplyBodyToJson(this);
}
