import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormCommentCard extends ConsumerWidget {
  final ShortFormCommentModel shortFormCommentModel;

  const ShortFormCommentCard({
    super.key,
    required this.shortFormCommentModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    late final bool isMyComment;

    if (user is UserModel && user.id == shortFormCommentModel.user.id) {
      isMyComment = true;
    } else {
      isMyComment = false;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              shortFormCommentModel.user.profileImg ?? '',
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.account_circle_outlined);
              },
              fit: BoxFit.cover,
              height: 36.0,
              width: 36.0,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: shortFormCommentModel.user.nickname,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (isMyComment)
                      WidgetSpan(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: ColorName.blue500,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            '내 댓글',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                shortFormCommentModel.comment.editedAt,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                shortFormCommentModel.comment.content,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.forum_outlined),
                  ),
                  Text(
                    shortFormCommentModel.replyCnt.toString(),
                  ),
                  const SizedBox(width: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up_outlined,
                      color: shortFormCommentModel.userLike
                          ? ColorName.blue500
                          : null,
                    ),
                  ),
                  Text(
                    shortFormCommentModel.commentLikeCnt.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}
