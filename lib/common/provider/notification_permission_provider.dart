import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/model/notification_permission_model.dart';

final notificationPermissionProvider = StateNotifierProvider.autoDispose<
    NotificationPermissionStateNotifier, NotificationPermissionModelBase>(
  (ref) => NotificationPermissionStateNotifier(ref),
);

class NotificationPermissionStateNotifier
    extends StateNotifier<NotificationPermissionModelBase> {
  final Ref ref;

  NotificationPermissionStateNotifier(this.ref)
      : super(NotificationPermissionLoading()) {
    fetchNotificationPermission();
  }

  Future<void> fetchNotificationPermission() async {
    final resp =
        await ref.read(pushNotificationServiceProvider).hasPermission();

    // 알림 권한이 거부되었을 때
    if (resp != AuthorizationStatus.authorized) {
      state = NotificationPermissionDenied();
      return;
    }

    // 알림 권한이 허용되었을 때
    state = NotificationPermissionGranted();
  }

  Future<void> requestNotificationPermission() async {
    final resp =
        await ref.read(pushNotificationServiceProvider).requestPermission();

    // 알림 권한이 허용된 경우
    if (resp == AuthorizationStatus.authorized) {
      state = NotificationPermissionGranted();
      return;
    }

    // iOS 에서 알림 설정을 허용/거부 둘 중 아무것도 선택하지 않은 경우 그냥 리턴
    // 이 경우 앱 설정 화면에서도 알림 설정을 변경할 수 없음
    if (resp == AuthorizationStatus.notDetermined) {
      return;
    }

    // 알림 권한이 거부된 경우
    // 직접 앱 설정 화면으로 이동해서 알림 권한을 허용하도록 유도
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}
