import 'package:json_annotation/json_annotation.dart';

part 'post_shortform_comment_model.g.dart';

@JsonSerializable()
class PostShortFormCommentBody {
  final int newsId;
  final String content;

  PostShortFormCommentBody({
    required this.newsId,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$PostShortFormCommentBodyToJson(this);
}
