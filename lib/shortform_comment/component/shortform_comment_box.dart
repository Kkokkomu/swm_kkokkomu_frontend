import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_body.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_post_card.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/component/shortform_comment_title.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

class ShortFormCommentBox extends StatelessWidget {
  final int newsId;
  final int? parentCommentId;
  final double maxCommentBodyHeight;
  final bool isReply;

  const ShortFormCommentBox({
    super.key,
    required this.newsId,
    required this.parentCommentId,
    required this.maxCommentBodyHeight,
    required this.isReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (_, ref, child) {
            final animationDurationAndHeight = ref.watch(
                shortFormCommentHeightControllerProvider((newsId)).select(
              (value) =>
                  (duration: value.animationDuration, height: value.height),
            ));

            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: AnimatedContainer(
                onEnd: () {
                  // 댓글창이 닫히고 애니메이션이 종료된 경우
                  // FloatingButton을 보이도록 설정
                  if (!ref
                      .read(shortFormCommentHeightControllerProvider((newsId)))
                      .isShortFormCommentVisible) {
                    ref
                        .read(shortFormCommentHeightControllerProvider((newsId))
                            .notifier)
                        .setShortFormFloatingButtonVisibility(true);
                  }
                },
                curve: Curves.easeInOut,
                height: animationDurationAndHeight.height,
                duration: animationDurationAndHeight.duration,
                width: double.infinity,
                color: ColorName.white000,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              ShortFormCommentTitle(
                newsId: newsId,
                maxCommentBodyHeight: maxCommentBodyHeight,
                isReply: isReply,
              ),
              ShortFormCommentBody(
                newsId: newsId,
                parentCommentId: isReply ? parentCommentId : null,
                isReply: isReply,
              ),
            ],
          ),
        ),
        ShortFormCommentPostCard(
          newsId: newsId,
          parentCommentId: isReply ? parentCommentId : null,
          isReply: isReply,
        ),
      ],
    );
  }
}
