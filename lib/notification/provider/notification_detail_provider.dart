import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/notification/model/notification_detail_model.dart';
import 'package:swm_kkokkomu_frontend/notification/repository/notification_detail_repository.dart';

final notificationDetailProvider = StateNotifierProvider.autoDispose
    .family<NotificationDetailStateNotifier, NotificationDetailModelBase, int>(
  (ref, notificationId) {
    final notificationDetailRepository =
        ref.watch(notificationDetailRepositoryProvider);

    return NotificationDetailStateNotifier(
      repository: notificationDetailRepository,
      notificationId: notificationId,
    );
  },
);

class NotificationDetailStateNotifier
    extends StateNotifier<NotificationDetailModelBase> {
  final NotificationDetailRepository repository;
  final int notificationId;

  NotificationDetailStateNotifier({
    required this.repository,
    required this.notificationId,
  }) : super(NotificationDetailModelLoading()) {
    getNotificationDetailInfo();
  }

  Future<void> getNotificationDetailInfo() async {
    // 로딩 상태로 변경
    state = NotificationDetailModelLoading();

    // 서버로부터 공지사항 정보 요청
    final resp = await repository.getNotificationDetailInfo(
      notificationId: notificationId,
    );

    final notificationDetailInfo = resp.data;

    // 정상적인 응답이 아니라면 에러 상태로 변경
    if (resp.success != true || notificationDetailInfo == null) {
      state = NotificationDetailModelError('공지사항 정보를 불러오는데 실패했습니다');
      return;
    }

    // 정상적인 응답이라면 상태 반영
    state = notificationDetailInfo;
  }
}
