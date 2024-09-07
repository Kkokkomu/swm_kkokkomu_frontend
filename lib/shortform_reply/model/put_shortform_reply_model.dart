import 'package:json_annotation/json_annotation.dart';

part 'put_shortform_reply_model.g.dart';

@JsonSerializable()
class PutShortFormReplyBody {
  final int replyId;
  final String content;

  PutShortFormReplyBody({
    required this.replyId,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$PutShortFormReplyBodyToJson(this);
}
