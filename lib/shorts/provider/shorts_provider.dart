import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shorts_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/repository/shorts_repository.dart';

final shortsProvider =
    StateNotifierProvider<ShortsStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortsRepository = ref.watch(shortsRepositoryProvider);

    return ShortsStateNotifier(shortsRepository: shortsRepository);
  },
);

class ShortsStateNotifier extends StateNotifier<CursorPaginationBase> {
  final ShortsRepository shortsRepository;

  ShortsStateNotifier({required this.shortsRepository})
      : super(CursorPagination<ShortsModel>(data: [])) {
    shortsPaginate();
  }

  Future<void> shortsPaginate() async {
    final pState = state as CursorPagination<ShortsModel>;

    state = CursorPaginationFetchingMore(data: pState.data);

    try {
      final resp = await shortsRepository.getShortsInfos();

      await Future.wait(
        resp.map(
          (shortsModel) => shortsModel.videoController.initialize(),
        ),
      );

      await Future.wait(
        resp.map(
          (shortsModel) => shortsModel.videoController.setLooping(true),
        ),
      );

      state = CursorPagination(
        data: [
          ...pState.data,
          ...resp,
        ],
      );
    } catch (e) {
      print(e);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
