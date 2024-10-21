import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_info_repository.dart';

final guestUserShortFormInfoProvider = StateNotifierProvider.autoDispose
    .family<GuestUserShortFormInfoStateNotifier, ShortFormModelBase, int>(
  (ref, newsId) {
    final shortFormInfoRepository = ref.watch(shortFormInfoRepositoryProvider);

    return GuestUserShortFormInfoStateNotifier(
      ref: ref,
      repository: shortFormInfoRepository,
      newsId: newsId,
    );
  },
);

class GuestUserShortFormInfoStateNotifier
    extends StateNotifier<ShortFormModelBase> {
  final Ref ref;
  final ShortFormInfoRepository repository;
  final int newsId;

  GuestUserShortFormInfoStateNotifier({
    required this.ref,
    required this.repository,
    required this.newsId,
  }) : super(ShortFormModelLoading()) {
    getShortFormInfo();
  }

  /// 뉴스 정보 요청
  Future<void> getShortFormInfo() async {
    state = ShortFormModelLoading();

    // 서버에 뉴스 정보 요청
    final resp = await repository.getNewsInfoForGuestUser(newsId: newsId);

    // 서버 요청 실패 시 에러 처리
    if (resp.success != true || resp.data == null) {
      state = ShortFormModelError('뉴스 정보를 불러오는 중 에러가 발생했어요\n다시 시도해주세요');
      return;
    }

    // 서버 요청 성공 시 상태 업데이트
    if (mounted) state = resp.data!;
  }
}
