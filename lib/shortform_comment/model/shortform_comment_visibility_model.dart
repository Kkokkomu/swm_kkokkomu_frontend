class ShortFormCommentVisibilityModel {
  final int newsId;
  final bool isShortFormCommentCreated;
  final bool isShortFormCommentVisible;

  ShortFormCommentVisibilityModel({
    required this.newsId,
    required this.isShortFormCommentCreated,
    required this.isShortFormCommentVisible,
  });

  ShortFormCommentVisibilityModel copyWith({
    bool? isShortFormCommentCreated,
    bool? isShortFormCommentVisible,
  }) =>
      ShortFormCommentVisibilityModel(
        newsId: newsId,
        isShortFormCommentCreated:
            isShortFormCommentCreated ?? this.isShortFormCommentCreated,
        isShortFormCommentVisible:
            isShortFormCommentVisible ?? this.isShortFormCommentVisible,
      );
}
