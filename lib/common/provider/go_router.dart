import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router_navigator_key_provider.dart';
import 'package:swm_kkokkomu_frontend/user/provider/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);
  final rootNavigatorKey = ref.read(rootNavigatorKeyProvider);

  return GoRouter(
    observers: Constants.flavor == Constants.prod && kReleaseMode
        ? [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ]
        : null,
    routes: provider.routes,
    initialLocation: '/splash',
    navigatorKey: rootNavigatorKey,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
