import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/provider/deep_link_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_update_fcm_token_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';

// 플러그인 인스턴스를 전역으로 정의
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const String notificationIcon =
    '@mipmap/ic_launcher'; // '@mipmap/ic_launcher'파일을 푸시 아이콘으로 사용합니다.

// 최상위 함수로 백그라운드 메시지 핸들러 정의
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

// 플러그인 초기화
Future<void> _initializeFlutterLocalNotificationsPlugin(Ref ref) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(notificationIcon);

  // const DarwinInitializationSettings initializationSettingsIOS =
  //     DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // 알림을 터치하여 앱을 실행한 경우의 처리
      debugPrint(
        '[FCM] [LocalNotification] [Payload] ${details.payload}',
      );
      // deeplink가 있는 경우, deeplink 실행
      final deeplink = details.payload;
      if (deeplink != null) {
        ref.read(deeplinkProvider.notifier).executeDeepLink(deeplink);
      }
    },
  );
}

// 안드로이드 알림 채널 초기화
Future<void> _initializeAndroidNotificationChannel() async {
  // 안드로이드 알림 채널 설정 및 생성
  for (final channelType in PushNotificationChannelType.values) {
    final channel = AndroidNotificationChannel(
      channelType.channelId,
      channelType.channelName,
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService>(
  (ref) => PushNotificationService(ref: ref),
);

class PushNotificationService {
  final Ref ref;
  bool isInitialized = false;

  PushNotificationService({
    required this.ref,
  });

  // 알림 초기화 메서드
  Future<void> initializeNotification() async {
    // 이미 초기화된 경우, 초기화하지 않음
    if (isInitialized) {
      return;
    }
    isInitialized = true;

    // ios 포그라운드 알림 설정
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 로컬 notification 및 알림 채널 설정은 안드로이드에서만 사용하므로 안드로이드에서만 초기화
    if (Platform.isAndroid) {
      await _initializeFlutterLocalNotificationsPlugin(ref);
      await _initializeAndroidNotificationChannel();
    }

    // 포그라운드 메시지 수신 리스너 설정
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        final notification = message.notification;
        final android = message.notification?.android;

        debugPrint(
            '[FCM] [Foreground] [Android Channel ID] ${android?.channelId}');
        debugPrint('[FCM] [Foreground] [Data] ${message.data}');

        // 안드로이드의 경우 포그라운드 상태에서 fcm에 의해 팝업 알림이 표시되지 않으므로
        // 로컬 notification을 이용해 표시함
        if (Platform.isAndroid && notification != null && android != null) {
          await _showLocalNotification(
            notification: notification,
            channelType: android.channelId == null
                ? PushNotificationChannelType.general
                : PushNotificationChannelType.fromId(android.channelId!),
            payload: message.data['deeplink'],
          ); // 로컬 알림 표시
        }
      },
    );

    // 알림을 터치하여 앱을 실행한 경우의 리스너 설정
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        debugPrint(
            '[FCM] [Pressed] [Android Channel ID] ${message.notification?.android?.channelId}');
        debugPrint('[FCM] [Pressed] [Data] ${message.data}');

        // deeplink가 있는 경우, deeplink 실행
        final deeplink = message.data['deeplink'] as String?;
        if (deeplink != null) {
          ref.read(deeplinkProvider.notifier).executeDeepLink(deeplink);
        }
      },
    );

    // 백그라운드 메시지 핸들러 설정
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // FCM 토큰이 갱신되었을 때 서버에 토큰 갱신 요청
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        debugPrint('[FCM Token] [Refresh] $token');
        // 서버에 토큰 갱신 요청
        await updateToken();
      },
    );

    // dev-debug 모드일 때는 토큰 출력
    if (Constants.flavor == Constants.dev && kDebugMode) {
      debugPrint('[FCM] [Token] ${await getToken()}');
    }

    // 앱이 종료된 상태에서 알림을 터치하여 앱을 실행한 경우의 로직 설정
    final firstMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (firstMessage != null) {
      // 실행시 터치한 알림이 FCM 알림인 경우
      debugPrint(
          '[FCM] [Terminated] [Android Channel ID] ${firstMessage.notification?.android?.channelId}');
      debugPrint('[FCM] [Terminated] [Data] ${firstMessage.data}');

      final deeplink = firstMessage.data['deeplink'] as String?;
      if (deeplink != null) {
        ref.read(deeplinkProvider.notifier).setInitialDeepLink(deeplink);
      }

      return;
    }

    // 실행시 터치한 알림이 로컬 알림인 경우
    final firstMessageByLocalNotification =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (firstMessageByLocalNotification != null &&
        firstMessageByLocalNotification.didNotificationLaunchApp) {
      final deeplink =
          firstMessageByLocalNotification.notificationResponse?.payload;

      debugPrint(
        '[FCM] [LocalNotification] [Terminated] [Payload] $deeplink',
      );

      // deeplink가 있는 경우, initial deeplink로 설정
      if (deeplink != null) {
        ref.read(deeplinkProvider.notifier).setInitialDeepLink(deeplink);
      }
    }
  }

  Future<bool> updateToken() async {
    final user = ref.read(userInfoProvider);

    // 로그인 상태가 아닌 경우, 서버에 토큰 갱신 요청을 보내지 않음
    if (user is! UserModel) {
      return false;
    }

    // 로그인 상태인 경우, 서버에 토큰 갱신 요청을 보냄
    final userRepository = ref.read(userRepositoryProvider);
    final token = await getToken();

    // 토큰이 없는 경우, 갱신 요청을 보내지 않음
    if (token == null) {
      return false;
    }

    // 토큰 갱신 요청
    final resp = await userRepository.updateFcmToken(
      body: PostUpdateFcmTokenBody(fcmToken: token),
    );

    // 정상적인 응답이 아니라면 실패 반환
    if (resp.success != true || resp.data == null) {
      return false;
    }

    return true;
  }

  // 로그아웃시 토큰 삭제를 위한 메서드
  Future<bool> deleteToken() async {
    final user = ref.read(userInfoProvider);

    // 로그인 상태가 아닌 경우, 서버에 토큰 삭제 요청을 보내지 않음
    if (user is! UserModel) {
      return false;
    }

    // 로그인 상태인 경우, 서버에 토큰 삭제 요청을 보냄
    final userRepository = ref.read(userRepositoryProvider);
    final token = await getToken();

    // 토큰이 없는 경우, 삭제 요청을 보내지 않음
    if (token == null) {
      return false;
    }

    // 토큰 삭제 요청
    final resp = await userRepository.deleteFcmToken(fcmToken: token);

    // 정상적인 응답이 아니라면 실패 반환
    if (resp.success != true) {
      return false;
    }

    return true;
  }

  // 알림 권한 요청 메서드
  Future<AuthorizationStatus> requestPermission() async {
    // 이미 권한이 허용된 경우, true 반환
    final permission = await hasPermission();
    if (permission == AuthorizationStatus.authorized) {
      return AuthorizationStatus.authorized;
    }

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus;
  }

  // 현재 알림 권한 상태를 가져오는 메서드
  Future<AuthorizationStatus> hasPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    return settings.authorizationStatus;
  }

  // 현재 FCM 토큰을 가져오는 메서드
  Future<String?> getToken() async =>
      await FirebaseMessaging.instance.getToken();

  // 로컬 알림 표시 메서드
  Future<void> localNotification({
    int id = 0,
    required PushNotificationChannelType channelType,
    required String? title,
    required String? body,
  }) async =>
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelType.channelId,
            channelType.channelName,
            icon: notificationIcon,
            importance: Importance.high,
          ),
        ),
      );

  // 로컬 알림을 표시하는 내부 메서드
  Future<void> _showLocalNotification({
    required RemoteNotification notification,
    required PushNotificationChannelType channelType,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelType.channelId,
          channelType.channelName,
          icon: notificationIcon,
          importance: Importance.high,
        ),
      ),
      payload: payload,
    );
  }
}
