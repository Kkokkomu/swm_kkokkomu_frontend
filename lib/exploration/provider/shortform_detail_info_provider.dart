// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
// import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_detail_info_box_state_provider.dart';
// import 'package:swm_kkokkomu_frontend/exploration/repository/shortform_detail_info_repository.dart';
// import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';

// final shortFormDetailInfoProvider = StateNotifierProvider.autoDispose.family<
//     ShortFormDetailInfoStateNotifier, ShortFormDetailInfoModelBase, int>(
//   (ref, newsId) {
//     final detailInfoRepository =
//         ref.watch(shortFormDetailInfoRepositoryProvider);

//     return ShortFormDetailInfoStateNotifier(
//       ref: ref,
//       repository: detailInfoRepository,
//       newsId: newsId,
//     );
//   },
// );

// class ShortFormDetailInfoStateNotifier
//     extends StateNotifier<ShortFormDetailInfoModelBase> {
//   final Ref ref;
//   final ShortFormDetailInfoRepository repository;
//   final int newsId;

//   ShortFormDetailInfoStateNotifier({
//     required this.ref,
//     required this.repository,
//     required this.newsId,
//   }) : super(ShortFormDetailInfoModelLoading()) {
//     getDetailInfo();
//   }

//   @override
//   void dispose() {
//     // 상세 정보 dispose 시
//     // 상세 정보 박스가 닫힌 상태로 변경
//     // 플로팅 버튼 보이도록 변경
//     // 바텀 네비게이션바 보이도록 변경
//     ref.read(shortFormDetailInfoBoxStateProvider(newsId).notifier).state =
//         false;
//     ref
//         .read(shortFormCommentHeightControllerProvider(newsId).notifier)
//         .setShortFormFloatingButtonVisibility(true);
//     ref
//         .read(bottomNavigationBarStateProvider.notifier)
//         .setBottomNavigationBarVisibility(true);
//     super.dispose();
//   }

//   Future<void> getDetailInfo() async {
//     state = ShortFormDetailInfoModelLoading();

//     final resp = await repository.getDetailInfo(newsId: newsId);
//     final detailInfo = resp.data;

//     if (resp.success != true || detailInfo == null) {
//       state = ShortFormDetailInfoModelError('상세 정보를 불러오는데 실패했습니다.');
//     }

//     state = detailInfo!;
//   }
// }
