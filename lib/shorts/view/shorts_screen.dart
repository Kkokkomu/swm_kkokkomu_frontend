import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shorts_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/provider/shorts_provider.dart';
import 'package:video_player/video_player.dart';

class ShortsScreen extends ConsumerStatefulWidget {
  const ShortsScreen({super.key});

  @override
  ConsumerState<ShortsScreen> createState() => _ShortScreenState();
}

class _ShortScreenState extends ConsumerState<ShortsScreen>
    with AutomaticKeepAliveClientMixin<ShortsScreen> {
  @override
  bool get wantKeepAlive => true;

  VideoPlayerController? _previousController;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final shorts = ref.watch(shortsProvider);

    if (shorts is CursorPaginationError) {
      return Center(
        child: Text(shorts.message),
      );
    }

    final cp = shorts as CursorPagination<ShortsModel>;

    if (shorts is! CursorPaginationFetchingMore && shorts.data.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다.'),
      );
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      onPageChanged: (value) async {
        if (value == cp.data.length - 2) {
          ref.read(shortsProvider.notifier).shortsPaginate();
        }

        if (_previousController != null) {
          _previousController!.seekTo(Duration.zero);
          _previousController!.pause();
        }

        if (value != cp.data.length) {
          await cp.data[value].videoController.seekTo(Duration.zero);
          cp.data[value].videoController.play();
          _previousController = cp.data[value].videoController;
        }
      },
      itemCount: cp.data.length + 1,
      itemBuilder: (context, index) {
        if (index == cp.data.length) {
          return Center(
            child: cp is CursorPaginationFetchingMore
                ? const CircularProgressIndicator()
                : const Text('마지막 데이터입니다.'),
          );
        }

        final shortsController = cp.data[index].videoController;

        return SingleShorts(
          shortsController: shortsController,
        );
      },
    );
  }
}

class SingleShorts extends StatefulWidget {
  final VideoPlayerController shortsController;

  const SingleShorts({
    super.key,
    required this.shortsController,
  });

  @override
  State<SingleShorts> createState() => _SingleShortsState();
}

class _SingleShortsState extends State<SingleShorts> {
  bool isTapped = false;
  Timer? _hideButtonTimer;

  @override
  void dispose() {
    _hideButtonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.shortsController.value.isPlaying) {
          widget.shortsController.pause();
        } else {
          widget.shortsController.play();
        }

        _hideButtonTimer?.cancel();
        _hideButtonTimer = Timer(const Duration(milliseconds: 1100), () {
          if (mounted) {
            setState(() {
              isTapped = false;
            });
          }
        });

        setState(() {
          isTapped = true;
        });
      },
      child: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 9.0,
                height: 16.0,
                child: VideoPlayer(widget.shortsController),
              ),
            ),
          ),
          if (widget.shortsController.value.isPlaying && isTapped)
            const Center(
              child: StartButton(),
            ),
          if (!widget.shortsController.value.isPlaying && isTapped)
            const Center(
              child: PauseButton(),
            ),
        ],
      ),
    );
  }
}

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scale = 1.0;
        });
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _scale = 0.0;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}

class PauseButton extends StatefulWidget {
  const PauseButton({
    super.key,
  });

  @override
  State<PauseButton> createState() => _PauseButtonState();
}

class _PauseButtonState extends State<PauseButton> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scale = 1.0;
        });
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _scale = 0.0;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.pause,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}
