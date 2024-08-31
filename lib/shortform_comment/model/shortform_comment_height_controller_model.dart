class ShortformCommentHeightControllerModel {
  final int newsId;
  final bool isShortFormCommentCreated;
  final bool isShortFormCommentVisible;
  final double height;
  final Duration animationDuration;

  ShortformCommentHeightControllerModel({
    required this.newsId,
    required this.isShortFormCommentCreated,
    required this.isShortFormCommentVisible,
    required this.height,
    required this.animationDuration,
  });

  ShortformCommentHeightControllerModel copyWith({
    int? newsId,
    bool? isShortFormCommentCreated,
    bool? isShortFormCommentVisible,
    double? height,
    Duration? animationDuration,
  }) {
    return ShortformCommentHeightControllerModel(
      newsId: newsId ?? this.newsId,
      isShortFormCommentCreated:
          isShortFormCommentCreated ?? this.isShortFormCommentCreated,
      isShortFormCommentVisible:
          isShortFormCommentVisible ?? this.isShortFormCommentVisible,
      height: height ?? this.height,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
