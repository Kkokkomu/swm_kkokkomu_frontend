import 'package:json_annotation/json_annotation.dart';

part 'post_set_not_interested_body.g.dart';

@JsonSerializable()
class PostSetNotInterestedBody {
  final int newsId;

  PostSetNotInterestedBody({
    required this.newsId,
  });

  Map<String, dynamic> toJson() => _$PostSetNotInterestedBodyToJson(this);
}
