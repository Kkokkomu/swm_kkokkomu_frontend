import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

class ShortFormCommentInputCard extends StatelessWidget {
  static const double _dividerHeight = 1.0;

  const ShortFormCommentInputCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 드래그시 숏폼 스와이프 되는 현상 방지
      onVerticalDragStart: (_) {},
      child: Column(
        children: [
          const Divider(
            height: _dividerHeight,
            thickness: 1.0,
          ),
          Container(
            width: double.infinity,
            height: Constants.bottomNavigationBarHeightWithSafeArea -
                _dividerHeight,
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
          ),
        ],
      ),
    );
  }
}
