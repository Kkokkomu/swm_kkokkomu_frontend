import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/hided_user_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/post_hide_user_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/repository/logged_in_user_blocked_user_list_repository.dart';

final loggedInUserBlockedUserListProvider = StateNotifierProvider.autoDispose<
    LoggedInUserBlockedUserListStateNotifier, HidedUserModelBase>(
  (ref) {
    final loggedInUserBlockedUserListRepository =
        ref.watch(loggedInUserBlockedUserListRepositoryProvider);

    return LoggedInUserBlockedUserListStateNotifier(
      loggedInUserBlockedUserListRepository:
          loggedInUserBlockedUserListRepository,
    );
  },
);

class LoggedInUserBlockedUserListStateNotifier
    extends StateNotifier<HidedUserModelBase> {
  final LoggedInUserBlockedUserListRepository
      loggedInUserBlockedUserListRepository;

  LoggedInUserBlockedUserListStateNotifier({
    required this.loggedInUserBlockedUserListRepository,
  }) : super(HidedUserModelLoading());

  Future<void> getHidedUserList() async {
    state = HidedUserModelLoading();

    // 서버로부터 차단된 유저 목록 요청
    final resp = await loggedInUserBlockedUserListRepository.getHidedUserList();
    final hidedUserList = resp.data;

    // 정상적인 응답이 아니라면 에러 상태로 변경
    if (resp.success != true || hidedUserList == null) {
      state = HidedUserModelError(message: '차단된 유저 목록을 불러오는데 실패했습니다.');
      return;
    }

    // 정상적인 응답이라면 상태 반영
    state = HidedUserModel(hidedUserList: hidedUserList);
  }

  Future<int?> hideUser(int userId) async {
    // 서버로부터 유저 차단 요청
    final resp = await loggedInUserBlockedUserListRepository.hideUser(
      body: PostHideUserModel(hidedUserId: userId),
    );

    // 차단된 유저 아이디
    final hidedUserId = resp.data?.hidedUserId;

    // 차단된 유저 아이디가 없다면, 즉, 실패했다면 null 반환
    if (resp.success != true || hidedUserId == null) {
      return null;
    }

    // 성공했다면 차단된 유저 아이디 반환
    return hidedUserId;
  }

  // 여기서 hiddenId는 userId가 아닌 차단 객체 Id임
  // getHidedUserList로 부터 불러온 객체의 id값을 사용해야 함
  Future<bool> unHideUser(int hiddenId) async {
    // 서버로부터 유저 차단 해제 요청
    final resp = await loggedInUserBlockedUserListRepository.unHideUser(
      hiddenId: hiddenId,
    );

    // 정상적인 응답이 아니라면 false 반환
    if (resp.success != true) {
      return false;
    }

    // 현재 HiddenUserModel 상태라면, 즉, 차단된 유저 목록을 가지고 있다면
    // 차단된 유저 목록에서 해당 아이디를 제외한 새로운 목록을 만들어 상태 변경
    if (state is HidedUserModel) {
      final prevState = state as HidedUserModel;

      state = HidedUserModel(
        hidedUserList: prevState.hidedUserList
            .where((element) => element.id != hiddenId)
            .toList(),
      );
    }

    return true;
  }
}
