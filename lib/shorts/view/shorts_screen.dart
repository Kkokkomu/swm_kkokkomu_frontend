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

        return GestureDetector(
          onTap: () {
            if (shortsController.value.isPlaying) {
              shortsController.pause();
            } else {
              shortsController.play();
            }
          },
          child: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 9.0,
                    height: 16.0,
                    child: VideoPlayer(shortsController),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
