class ShortformCommentHeightControllerModel {
  final int newsId;
  final int? parentCommentId;
  final bool isShortFormCommentCreated;
  final bool isShortFormCommentVisible;
  final bool isReplyVisible;
  final bool isShortFormFloatingButtonVisible;
  final double height;
  final Duration animationDuration;

  ShortformCommentHeightControllerModel({
    required this.newsId,
    this.parentCommentId,
    required this.isShortFormCommentCreated,
    required this.isShortFormCommentVisible,
    required this.isReplyVisible,
    required this.isShortFormFloatingButtonVisible,
    required this.height,
    required this.animationDuration,
  });

  ShortformCommentHeightControllerModel copyWith({
    int? newsId,
    int? parentCommentId,
    bool? isShortFormCommentCreated,
    bool? isShortFormCommentVisible,
    bool? isReplyVisible,
    bool? isShortFormFloatingButtonVisible,
    double? height,
    Duration? animationDuration,
  }) {
    return ShortformCommentHeightControllerModel(
      newsId: newsId ?? this.newsId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isShortFormCommentCreated:
          isShortFormCommentCreated ?? this.isShortFormCommentCreated,
      isShortFormCommentVisible:
          isShortFormCommentVisible ?? this.isShortFormCommentVisible,
      isReplyVisible: isReplyVisible ?? this.isReplyVisible,
      isShortFormFloatingButtonVisible: isShortFormFloatingButtonVisible ??
          this.isShortFormFloatingButtonVisible,
      height: height ?? this.height,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
