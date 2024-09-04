import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router_navigator_key_provider.dart';
import 'package:swm_kkokkomu_frontend/common/view/root_tab.dart';
import 'package:swm_kkokkomu_frontend/common/view/splash_screen.dart';
import 'package:swm_kkokkomu_frontend/exploration/view/exploration_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform/view/shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/view/blocked_user_management_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/login_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/my_page_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/register_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) {
    return AuthProvider(
      ref: ref,
      rootNavigationKey: ref.read(rootNavigatorKeyProvider),
    );
  },
);

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  final GlobalKey<NavigatorState> rootNavigationKey;

  AuthProvider({
    required this.ref,
    required this.rootNavigationKey,
  }) {
    ref.listen<UserModelBase?>(
      userInfoProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<RouteBase> get routes => [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigationKey,
          builder: (_, state, navigationShell) =>
              RootTab(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/exploration',
                  name: ExplorationScreen.routeName,
                  builder: (_, __) => const ExplorationScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  name: ShortFormScreen.routeName,
                  builder: (_, __) => const ShortFormScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/mypage',
                  name: MyPageScreen.routeName,
                  builder: (_, __) => const MyPageScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigationKey,
                      path: 'manage-blocked-users',
                      name: BlockedUserManagementScreen.routeName,
                      builder: (_, __) => const BlockedUserManagementScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: RegisterScreen.routeName,
          builder: (_, __) => const RegisterScreen(),
        ),
      ];

  void authErrorLogout() {
    ref.read(userInfoProvider.notifier).logout(isAuthErrorLogout: true);
  }

  String? redirectLogic(BuildContext _, GoRouterState state) {
    final UserModelBase user = ref.read(userInfoProvider);

    // SplashScreen인지 여부
    final isSplashScreen = state.fullPath == CustomRoutePath.splash;
    // 로그인 페이지인지 여부
    final isLoggingIn = state.fullPath == CustomRoutePath.login;

    // InitialUserModel
    // 한번도 로그인 해본 적 없는 유저라면
    // 무조건 로그인 페이지로 이동
    if (user is InitialUserModel) {
      return isLoggingIn ? null : CustomRoutePath.login;
    }

    // UnregisteredUserModel
    // UnregisteredUserModel 상태인 경우 무조건 회원가입 페이지로 이동
    if (user is UnregisteredUserModel) {
      return state.fullPath != CustomRoutePath.register
          ? CustomRoutePath.register
          : null;
    }

    // UserModelError
    // 로그인 에러 상태인 경우 무조건 로그인 페이지로 이동
    if (user is UserModelError) {
      return !isLoggingIn ? CustomRoutePath.login : null;
    }

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이거나 RegisterScreen이면
    // 홈(숏폼화면)으로 이동
    if (user is UserModel) {
      return isLoggingIn ||
              isSplashScreen ||
              state.fullPath == CustomRoutePath.register
          ? CustomRoutePath.home
          : null;
    }

    // GuestUserModel
    // 게스트 유저 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면
    // 홈(숏폼화면)으로 이동
    if (user is GuestUserModel && (isLoggingIn || isSplashScreen)) {
      return CustomRoutePath.home;
    }

    return null;
  }
}
