import 'package:json_annotation/json_annotation.dart';

part 'post_news_id_body.g.dart';

@JsonSerializable()
class PostNewsIdBody {
  final int newsId;

  PostNewsIdBody({
    required this.newsId,
  });

  Map<String, dynamic> toJson() => _$PostNewsIdBodyToJson(this);
}
