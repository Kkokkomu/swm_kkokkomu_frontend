import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_body.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_input_card.dart';

class ShortFormCommentBox extends ConsumerWidget {
  final int newsId;
  final double maxShortFormCommentBoxHeight;

  const ShortFormCommentBox({
    super.key,
    required this.newsId,
    required this.maxShortFormCommentBoxHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    return Column(
      children: [
        ShortFormCommentBody(
          maxCommentBodyHeight: maxShortFormCommentBoxHeight -
              Constants.bottomNavigationBarHeightWithSafeArea,
          newsId: newsId,
        ),
        // 하단 네비게이션바가 보이지 않을 때만 댓글 입력창을 보여줌
        if (!bottomNavigationBarState.isBottomNavigationBarVisible)
          const ShortFormCommentInputCard(),
      ],
    );
  }
}
