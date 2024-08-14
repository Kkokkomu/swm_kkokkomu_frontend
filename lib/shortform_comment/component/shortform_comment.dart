import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/colors.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_visibility_provider.dart';

class ShortFormComment extends ConsumerStatefulWidget {
  final double parentHeight;
  final int newsID;

  const ShortFormComment({
    super.key,
    required this.parentHeight,
    required this.newsID,
  });

  @override
  ConsumerState<ShortFormComment> createState() => _ShortFormCommentState();
}

class _ShortFormCommentState extends ConsumerState<ShortFormComment> {
  double _commentHeight = 0.0;
  late void Function(DragUpdateDetails) _onVerticalDragUpdate;
  late void Function(DragEndDetails) _onVerticalDragEnd;
  bool _isAnimated = true;
  late double _commentSizeLarge;
  late double _commentSizeMedium;
  final double _commentSizeSmall = 0.0;
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _commentSizeLarge = widget.parentHeight;
    _commentSizeMedium = widget.parentHeight * 0.6;

    _onVerticalDragUpdate = (details) {
      _commentHeight -= details.delta.dy;
      if (_commentHeight < 0.0) {
        _commentHeight = 0.0;
      } else if (_commentHeight > _commentSizeLarge) {
        _commentHeight = _commentSizeLarge;
      }
      setState(() {
        _isAnimated = false;
      });
    };

    _onVerticalDragEnd = (details) {
      bool isScrollUp = details.velocity.pixelsPerSecond.dy <= -500.0;
      bool isScrollDown = details.velocity.pixelsPerSecond.dy >= 500.0;

      if (_commentHeight >= widget.parentHeight * 0.75) {
        if (isScrollDown) {
          setCommentSizeMedium();
        } else {
          setCommentSizeLarge();
        }
      } else if (_commentHeight <= widget.parentHeight * 0.45) {
        if (isScrollUp) {
          setCommentSizeMedium();
        } else {
          setCommentSizeSmall();
        }
      } else {
        if (isScrollUp) {
          setCommentSizeLarge();
        } else if (isScrollDown) {
          setCommentSizeSmall();
        } else {
          setCommentSizeMedium();
        }
      }
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setCommentSizeMedium();
      }
    });
  }

  void setCommentSizeLarge() {
    setState(() {
      _commentHeight = _commentSizeLarge;
      _isAnimated = true;
    });
  }

  void setCommentSizeMedium() {
    setState(() {
      _commentHeight = _commentSizeMedium;
      _isAnimated = true;
    });
  }

  void setCommentSizeSmall() {
    setState(() {
      _commentHeight = _commentSizeSmall;
      _isAnimated = true;
    });

    ref
        .read(shortFormCommentVisibilityProvider(widget.newsID).notifier)
        .toggleShortFormCommentVisibility();
  }

  @override
  Widget build(BuildContext context) {
    final shortFormCommentVisibility =
        ref.watch(shortFormCommentVisibilityProvider(widget.newsID));

    if (!isFirstBuild &&
        shortFormCommentVisibility.isShortFormCommentVisible &&
        _commentHeight == 0.0) {
      setCommentSizeMedium();
    }

    isFirstBuild = false;

    return AnimatedContainer(
      duration: _isAnimated ? const Duration(milliseconds: 300) : Duration.zero,
      width: double.infinity,
      height: shortFormCommentVisibility.isShortFormCommentVisible
          ? _commentHeight
          : 0.0,
      color: BACKGROUND_COLOR,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: ShortFormCommentHeaderDelegate(
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  closeComment: setCommentSizeSmall,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
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
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
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
                                '사용자 $index',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                '2021.10.10 오후 10:00',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                  '댓글 $index ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.forum_outlined),
                                  ),
                                  const Text('0'),
                                  const SizedBox(width: 16.0),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.thumb_up_outlined),
                                  ),
                                  const Text('0'),
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
                  },
                  separatorBuilder: (context, index) {
                    return const Column(
                      children: [
                        Divider(
                          height: 1.0,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 16.0),
                      ],
                    );
                  },
                  itemCount: 10,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 72.0,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                const Divider(
                  height: 1.0,
                  thickness: 1.0,
                ),
                Container(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShortFormCommentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final void Function(DragUpdateDetails) _onVerticalDragUpdate;
  final void Function(DragEndDetails) _onVerticalDragEnd;
  final void Function() _closeComment;

  ShortFormCommentHeaderDelegate({
    required void Function(DragUpdateDetails) onVerticalDragUpdate,
    required void Function(DragEndDetails) onVerticalDragEnd,
    required void Function() closeComment,
  })  : _onVerticalDragUpdate = onVerticalDragUpdate,
        _onVerticalDragEnd = onVerticalDragEnd,
        _closeComment = closeComment;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Container(
        color: BACKGROUND_COLOR,
        child: Column(
          children: [
            const SizedBox(height: 6.0),
            Container(
              width: 54.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    '댓글',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _closeComment,
                  icon: const Icon(
                    Icons.close,
                    size: 28.0,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 1.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 67.0;

  @override
  double get minExtent => 67.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
