import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';

final detailUserInfoProvider = StateNotifierProvider.autoDispose<
    DetailUserInfoStateNotifier, DetailUserModelBase>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);

    return DetailUserInfoStateNotifier(
      ref: ref,
      userRepository: userRepository,
    );
  },
);

class DetailUserInfoStateNotifier extends StateNotifier<DetailUserModelBase> {
  final Ref ref;
  final UserRepository userRepository;

  DetailUserInfoStateNotifier({
    required this.ref,
    required this.userRepository,
  }) : super(DetailUserModelLoading()) {
    getDetailUserInfo();
  }

  Future<void> getDetailUserInfo() async {
    // 로딩 상태로 변경
    state = DetailUserModelLoading();

    // 서버로부터 유저 정보 요청
    final resp = await userRepository.getDetailUserInfo();

    final detailInfo = resp.data;

    // 정상적인 응답이 아니라면 에러 상태로 변경
    if (resp.success != true || detailInfo == null) {
      state = DetailUserModelError('유저 정보를 불러오는데 실패했습니다.');
      return;
    }

    // 정상적인 응답이라면 상태 반영
    state = detailInfo;
  }
}
