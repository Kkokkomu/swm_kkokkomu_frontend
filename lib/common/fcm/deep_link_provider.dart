import 'package:flutter_riverpod/flutter_riverpod.dart';

final deeplinkProvider = StateNotifierProvider<DeepLinkStateNotifier, String?>(
  (ref) => DeepLinkStateNotifier(),
);

class DeepLinkStateNotifier extends StateNotifier<String?> {
  DeepLinkStateNotifier() : super(null);

  void setInitialDeepLink(String deeplink) => state = deeplink;

  // 앱이 실행된 후, 최초 딥링크 실행
  // FCM 푸시 알림을 통해 앱이 실행된 경우에 실행됨
  void executeInitialDeepLink() {
    if (state != null) {
      executeDeepLink(state!);
      state = null;
    }
  }

  // 딥링크 실행
  void executeDeepLink(String deeplink) {
    // TODO : 딥링크 로직 구현해야 함
  }
}
