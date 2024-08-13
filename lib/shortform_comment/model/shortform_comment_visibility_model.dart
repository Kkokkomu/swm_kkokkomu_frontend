class ShortFormCommentVisibilityModel {
  final int newsId;
  final bool isShortFormCommentTapped;
  final bool isShortFormCommentVisible;

  ShortFormCommentVisibilityModel({
    required this.newsId,
    required this.isShortFormCommentTapped,
    required this.isShortFormCommentVisible,
  });

  ShortFormCommentVisibilityModel copyWith({
    bool? isShortFormCommentTapped,
    bool? isShortFormCommentVisible,
  }) =>
      ShortFormCommentVisibilityModel(
        newsId: newsId,
        isShortFormCommentTapped:
            isShortFormCommentTapped ?? this.isShortFormCommentTapped,
        isShortFormCommentVisible:
            isShortFormCommentVisible ?? this.isShortFormCommentVisible,
      );
}
