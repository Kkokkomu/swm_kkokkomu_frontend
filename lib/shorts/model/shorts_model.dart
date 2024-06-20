import 'package:json_annotation/json_annotation.dart';
import 'package:video_player/video_player.dart';

part 'shorts_model.g.dart';

@JsonSerializable()
class ShortsModel {
  final String videoUrl;
  final VideoPlayerController videoController;

  ShortsModel({
    required this.videoUrl,
  }) : videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

  factory ShortsModel.fromJson(Map<String, dynamic> json) =>
      _$ShortsModelFromJson(json);
}
