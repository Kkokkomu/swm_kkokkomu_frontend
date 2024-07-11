class ShortsCommentVisibleModel {
  final int id;
  final bool isShortsCommentTapped;
  final bool isShortsCommentVisible;

  ShortsCommentVisibleModel({
    required this.id,
    required this.isShortsCommentTapped,
    required this.isShortsCommentVisible,
  });

  ShortsCommentVisibleModel copyWith({
    bool? isShortsCommentTapped,
    bool? isShortsCommentVisible,
  }) {
    return ShortsCommentVisibleModel(
      id: id,
      isShortsCommentTapped:
          isShortsCommentTapped ?? this.isShortsCommentTapped,
      isShortsCommentVisible:
          isShortsCommentVisible ?? this.isShortsCommentVisible,
    );
  }
}
