class ShortformCommentHeightControllerModel {
  final int newsId;
  final double height;
  final Duration animationDuration;

  ShortformCommentHeightControllerModel({
    required this.newsId,
    required this.height,
    required this.animationDuration,
  });

  ShortformCommentHeightControllerModel copyWith({
    int? newsId,
    double? height,
    Duration? animationDuration,
  }) {
    return ShortformCommentHeightControllerModel(
      newsId: newsId ?? this.newsId,
      height: height ?? this.height,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
