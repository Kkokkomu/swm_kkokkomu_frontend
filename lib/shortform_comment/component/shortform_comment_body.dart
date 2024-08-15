import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/colors.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_visibility_provider.dart';

class ShortFormCommentBody extends ConsumerStatefulWidget {
  final int newsId;
  final double maxCommentBodyHeight;

  const ShortFormCommentBody({
    super.key,
    required this.newsId,
    required this.maxCommentBodyHeight,
  });

  @override
  ConsumerState<ShortFormCommentBody> createState() =>
      _ShortFormCommentBodyState();
}

class _ShortFormCommentBodyState extends ConsumerState<ShortFormCommentBody> {
  double _commentBodyHeight = 0.0;
  late void Function(DragUpdateDetails) _onVerticalDragUpdate;
  late void Function(DragEndDetails) _onVerticalDragEnd;
  bool _isAnimated = true;
  late double _commentBodySizeLarge;
  late double _commentBodySizeMedium;
  final double _commentBodySizeSmall = 0.0;
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _commentBodySizeLarge = widget.maxCommentBodyHeight;
    _commentBodySizeMedium = _commentBodySizeLarge * 0.6;

    _onVerticalDragUpdate = (details) {
      _commentBodyHeight -= details.delta.dy;

      if (_commentBodyHeight < 0.01) {
        _commentBodyHeight = 0.01;
      } else if (_commentBodyHeight > _commentBodySizeLarge) {
        _commentBodyHeight = _commentBodySizeLarge;
      }
      setState(() {
        _isAnimated = false;
      });
    };

    _onVerticalDragEnd = (details) {
      bool isScrollUp = details.velocity.pixelsPerSecond.dy <= -500.0;
      bool isScrollDown = details.velocity.pixelsPerSecond.dy >= 500.0;

      if (_commentBodyHeight >= widget.maxCommentBodyHeight * 0.75) {
        if (isScrollDown) {
          setCommentBodySizeMedium();
        } else {
          setCommentBodySizeLarge();
        }
      } else if (_commentBodyHeight <= widget.maxCommentBodyHeight * 0.45) {
        if (isScrollUp) {
          setCommentBodySizeMedium();
        } else {
          setCommentBodySizeSmall();
        }
      } else {
        if (isScrollUp) {
          setCommentBodySizeLarge();
        } else if (isScrollDown) {
          setCommentBodySizeSmall();
        } else {
          setCommentBodySizeMedium();
        }
      }
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setCommentBodySizeMedium();
      }
    });
  }

  void setCommentBodySizeLarge() {
    setState(() {
      _commentBodyHeight = _commentBodySizeLarge;
      _isAnimated = true;
    });
  }

  void setCommentBodySizeMedium() {
    setState(() {
      _commentBodyHeight = _commentBodySizeMedium;
      _isAnimated = true;
    });
  }

  void setCommentBodySizeSmall() {
    setState(() {
      _commentBodyHeight = _commentBodySizeSmall;
      _isAnimated = true;
    });

    ref
        .read(shortFormCommentVisibilityProvider(widget.newsId).notifier)
        .toggleShortFormCommentVisibility();
  }

  @override
  Widget build(BuildContext context) {
    final shortFormCommentVisibility =
        ref.watch(shortFormCommentVisibilityProvider(widget.newsId));

    if (!isFirstBuild &&
        shortFormCommentVisibility.isShortFormCommentVisible &&
        _commentBodyHeight == 0.0) {
      setCommentBodySizeMedium();
    }

    isFirstBuild = false;

    return AnimatedContainer(
      duration: _isAnimated
          ? Constants.shortFormCommentAnimationDuration
          : Duration.zero,
      width: double.infinity,
      height: shortFormCommentVisibility.isShortFormCommentVisible
          ? _commentBodyHeight
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
                  closeComment: setCommentBodySizeSmall,
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
            ],
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
