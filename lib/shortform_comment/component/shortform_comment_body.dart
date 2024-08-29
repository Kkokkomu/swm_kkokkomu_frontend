import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_card.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_custom_scroll_view.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class ShortFormCommentBody extends ConsumerWidget {
  final int newsId;
  final double maxCommentBodyHeight;

  const ShortFormCommentBody({
    super.key,
    required this.newsId,
    required this.maxCommentBodyHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortFormCommentHeightController =
        ref.watch(shortFormCommentHeightControllerProvider((newsId)));

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: shortFormCommentHeightController.animationDuration,
      width: double.infinity,
      height: shortFormCommentHeightController.height,
      color: ColorName.white000,
      child: ShortFormCommentCustomScrollView(
        newsId: newsId,
        maxCommentBodyHeight: maxCommentBodyHeight,
        itemBuilder: (context, index, shortFormCommentModel) =>
            ShortFormCommentCard(shortFormCommentModel: shortFormCommentModel),
      ),
    );
  }
}
