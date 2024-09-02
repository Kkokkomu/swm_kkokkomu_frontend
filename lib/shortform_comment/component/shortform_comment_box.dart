import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_section.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_post_card.dart';

class ShortFormCommentBox extends StatelessWidget {
  final int newsId;
  final double maxShortFormCommentBoxHeight;

  const ShortFormCommentBox({
    super.key,
    required this.newsId,
    required this.maxShortFormCommentBoxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShortFormCommentSection(
          maxCommentBodyHeight: maxShortFormCommentBoxHeight -
              Constants.bottomNavigationBarHeightWithSafeArea,
          newsId: newsId,
        ),
        ShortFormCommentPostCard(newsId: newsId),
      ],
    );
  }
}
