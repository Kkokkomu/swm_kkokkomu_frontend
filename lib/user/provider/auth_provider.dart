import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router_navigator_key_provider.dart';
import 'package:swm_kkokkomu_frontend/common/view/root_tab.dart';
import 'package:swm_kkokkomu_frontend/common/view/splash_screen.dart';
import 'package:swm_kkokkomu_frontend/exploration/view/exploration_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform/view/shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/view/login_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/my_page_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/register_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
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
          parentNavigatorKey: ref.read(rootNavigatorKeyProvider),
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
                  path: '/shortform',
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

    final logginIn = state.fullPath == '/login';

    // InitialUserModel
    // 한번도 로그인 해본 적 없는 유저라면
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user is InitialUserModel) {
      return logginIn ? null : '/login';
    }

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이거나 RegisterScreen이면
    // 홈(숏폼화면)으로 이동
    if (user is UserModel) {
      return logginIn ||
              state.fullPath == '/splash' ||
              state.fullPath == '/register'
          ? '/shortform'
          : null;
    }

    // GuestUserModel
    // 게스트 유저 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면
    // 홈(숏폼화면)으로 이동
    if (user is GuestUserModel) {
      return logginIn || state.fullPath == '/splash' ? '/shortform' : null;
    }

    // UnregisteredUserModel
    if (user is UnregisteredUserModel) {
      return state.fullPath != '/register' ? '/register' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
