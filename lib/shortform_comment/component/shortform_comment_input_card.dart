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
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return const ShortFormCommentInputInBottomSheet();
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          border: InputBorder.none,
                        ),
                      ),
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

class ShortFormCommentInputInBottomSheet extends StatelessWidget {
  const ShortFormCommentInputInBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 80.0,
        child: Column(
          children: [
            const Divider(
              height: ShortFormCommentInputCard._dividerHeight,
              thickness: 1.0,
            ),
            Container(
              color: Colors.white,
              height: 79.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
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
      ),
    );
  }
}
