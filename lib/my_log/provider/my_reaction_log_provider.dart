import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_pagination_shortform_repository.dart';

final myReactionLogProvider = StateNotifierProvider.autoDispose<
    LoggedInUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(loggedInUserPaginationShortFormRepositoryProvider);

    return LoggedInUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/mypage/log/reaction',
      ref: ref,
    );
  },
);
