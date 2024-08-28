import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_visibility_model.dart';

final shortFormCommentVisibilityProvider = StateNotifierProvider.family
    .autoDispose<ShortFormCommentVisibilityStateNotifier,
        ShortFormCommentVisibilityModel, int>(
  (ref, newsID) {
    return ShortFormCommentVisibilityStateNotifier(
      ref: ref,
      newsID: newsID,
    );
  },
);

class ShortFormCommentVisibilityStateNotifier
    extends StateNotifier<ShortFormCommentVisibilityModel> {
  final Ref ref;
  final int newsID;

  ShortFormCommentVisibilityStateNotifier({
    required this.ref,
    required this.newsID,
  }) : super(
          ShortFormCommentVisibilityModel(
            newsId: newsID,
            isShortFormCommentCreated: false,
            isShortFormCommentVisible: false,
          ),
        );

  void setShortFormCommentVisibility(bool isVisible) {
    state = state.copyWith(
      isShortFormCommentCreated: true,
      isShortFormCommentVisible: isVisible,
    );
  }
}
