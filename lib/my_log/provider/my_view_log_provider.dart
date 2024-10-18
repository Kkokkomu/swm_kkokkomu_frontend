import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_view_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/repository/my_view_log_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final myViewLogProvider = StateNotifierProvider.autoDispose<
    MyViewLogStateNotifier, CursorPaginationBase>(
  (ref) {
    final myViewLogRepository = ref.watch(myViewLogRepositoryProvider);

    return MyViewLogStateNotifier(
      myViewLogRepository,
      '',
      ref: ref,
    );
  },
);

class MyViewLogStateNotifier
    extends CursorPaginationProvider<MyViewLogModel, MyViewLogRepository> {
  final Ref ref;

  MyViewLogStateNotifier(
    super.repository,
    super.apiPath, {
    required this.ref,
  });

  Future<bool> deleteAllLog() async {
    // 로그 삭제 전 상태를 저장
    final prevState = _getValidPrevState();

    if (prevState == null) {
      return false;
    }

    // 로그 삭제 요청
    final resp = await repository.deleteAllLog();

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    // 로그 삭제
    prevState.items.clear();
    // 모든 로그가 삭제되었으므로 더 불러올 데이터가 없음
    // pageInfo의 isLast를 true로 변경
    state = prevState.copyWith(
      pageInfo: prevState.pageInfo.copyWith(
        isLast: true,
      ),
    );

    return true;
  }

  Future<bool> deleteSelectedLog(Set<int> logIdList) async {
    // 로그 삭제 전 상태를 저장
    final prevState = _getValidPrevState();

    if (prevState == null || logIdList.isEmpty) {
      return false;
    }

    // 로그 삭제 요청
    final resp = await repository.deleteSelectedLog(
      newsIdList: logIdList.join(','),
    );

    // success값이 true가 아니면 실패 처리
    if (resp.success != true) {
      return false;
    }

    // 로그 삭제
    prevState.items.removeWhere((element) => logIdList.contains(element.id));
    state = prevState.copyWith();

    return true;
  }

  // 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<MyViewLogModel>? _getValidPrevState() =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)인 경우
      // 유효한 상태로 간주
      state is CursorPagination<MyViewLogModel> &&
              ref.read(userInfoProvider) is UserModel
          ? state as CursorPagination<MyViewLogModel>
          : null;
}
