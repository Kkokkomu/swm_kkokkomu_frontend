import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';

class ShortFormCommentCard extends StatelessWidget {
  final ShortFormCommentModel shortFormCommentModel;

  const ShortFormCommentCard({
    super.key,
    required this.shortFormCommentModel,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(
                shortFormCommentModel.user.nickname,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
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
                    icon: const Icon(Icons.thumb_up_outlined),
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
