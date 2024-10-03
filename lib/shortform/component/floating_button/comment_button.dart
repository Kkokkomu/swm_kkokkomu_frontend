import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class CommentButton extends StatelessWidget {
  final WidgetRef ref;
  final int newsId;
  final double maxCommentHeight;

  const CommentButton({
    super.key,
    required this.ref,
    required this.newsId,
    required this.maxCommentHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      width: 64.0,
      height: 64.0,
      icon: Assets.icons.svg.icComment.svg(),
      label: '댓글',
      onTap: () => ref
          .read(shortFormCommentHeightControllerProvider(newsId).notifier)
          .setCommentBodySizeMedium(maxCommentHeight),
    );
  }
}
