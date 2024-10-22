import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/my_comment_log_model.dart';
import 'package:swm_kkokkomu_frontend/my_log/repository/my_comment_log_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final myCommentLogProvider = StateNotifierProvider.autoDispose<
    MyCommentLogStateNotifier, CursorPaginationBase>(
  (ref) {
    final myCommentLogRepository = ref.watch(myCommentLogRepositoryProvider);

    return MyCommentLogStateNotifier(
      myCommentLogRepository,
      '',
      ref: ref,
    );
  },
);

class MyCommentLogStateNotifier extends CursorPaginationProvider<
    MyCommentLogModel, MyCommentLogRepository> {
  final Ref ref;

  MyCommentLogStateNotifier(
    super.repository,
    super.apiPath, {
    required this.ref,
  });

  // 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<MyCommentLogModel>? _getValidPrevState() =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)인 경우
      // 유효한 상태로 간주
      state is CursorPagination<MyCommentLogModel> &&
              ref.read(userInfoProvider) is UserModel
          ? state as CursorPagination<MyCommentLogModel>
          : null;
}
