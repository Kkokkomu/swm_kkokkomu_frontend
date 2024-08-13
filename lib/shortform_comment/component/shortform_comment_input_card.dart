import 'package:flutter/material.dart';

class ShortFormCommentInputCard extends StatelessWidget {
  const ShortFormCommentInputCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16.0),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요.',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
