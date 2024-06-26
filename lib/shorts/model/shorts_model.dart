import 'package:json_annotation/json_annotation.dart';
import 'package:video_player/video_player.dart';

part 'shorts_model.g.dart';

@JsonSerializable()
class ShortsModel {
  final id;
  final String shortform_url;
  final String related_url;
  final String youtube_url;
  final VideoPlayerController videoController;

  ShortsModel({
    required this.id,
    required this.shortform_url,
    required this.related_url,
    required this.youtube_url,
  }) : videoController =
            VideoPlayerController.networkUrl(Uri.parse(shortform_url));

  factory ShortsModel.fromJson(Map<String, dynamic> json) =>
      _$ShortsModelFromJson(json);
}
