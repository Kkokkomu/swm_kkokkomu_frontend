import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_log_model.dart';
import 'package:swm_kkokkomu_frontend/notification/repository/notification_log_repository.dart';

final notificationLogProvider = StateNotifierProvider.autoDispose<
    NotificationLogStateNotifier, CursorPaginationBase>(
  (ref) {
    final notificationLogRepository =
        ref.watch(notificationLogRepositoryProvider);

    return NotificationLogStateNotifier(
      notificationLogRepository,
      '',
    );
  },
);

class NotificationLogStateNotifier extends CursorPaginationProvider<
    NotificationLogModel, NotificationLogRepository> {
  NotificationLogStateNotifier(
    super.repository,
    super.apiPath,
  );
}
