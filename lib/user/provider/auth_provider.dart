import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/provider/go_router_navigator_key_provider.dart';
import 'package:swm_kkokkomu_frontend/common/view/permission_screen.dart';
import 'package:swm_kkokkomu_frontend/common/view/root_tab.dart';
import 'package:swm_kkokkomu_frontend/common/view/search_screen.dart';
import 'package:swm_kkokkomu_frontend/common/view/splash_screen.dart';
import 'package:swm_kkokkomu_frontend/exploration/view/exploration_screen.dart';
import 'package:swm_kkokkomu_frontend/exploration/view/exploration_shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_comment_log_shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_reaction_log_shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_view_log_shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/notification/view/notification_detail_screen.dart';
import 'package:swm_kkokkomu_frontend/notification/view/notification_shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform/view/shortform_filter_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform/view/shortform_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/view/search_shortform_list_screen.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/view/shortform_searched_screen.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/view/account_deletion_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/app_info_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/blocked_user_management_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/edit_personal_info_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/login_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_comment_log_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_reaction_log_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/my_page_screen.dart';
import 'package:swm_kkokkomu_frontend/my_log/view/my_view_log_screen.dart';
import 'package:swm_kkokkomu_frontend/notification/view/notification_screen.dart';
import 'package:swm_kkokkomu_frontend/notification/view/notification_setting_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/official_sns_account_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/open_source_licenses_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/profile_screen.dart';
import 'package:swm_kkokkomu_frontend/user/view/register_agreement_screen.dart';
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
          builder: (_, __, navigationShell) =>
              RootTab(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/exploration',
                  name: ExplorationScreen.routeName,
                  builder: (_, __) => const ExplorationScreen(),
                  routes: [
                    GoRoute(
                      path: 'shortform',
                      name: ExplorationShortFormScreen.routeName,
                      builder: (_, state) => ExplorationShortFormScreen(
                        initialPageIndex: state.extra as int? ?? 0,
                      ),
                    ),
                    GoRoute(
                      path: 'search-shortform-list',
                      name: SearchShortFormListScreen.routeName,
                      builder: (_, state) {
                        final extra = state.extra as Map<String, dynamic>?;

                        return SearchShortFormListScreen(
                          searchKeyword: extra?[GoRouterExtraKeys.searchKeyword]
                                  as String? ??
                              '',
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'shortform',
                          name: ShortFormSearchedScreen.routeName,
                          builder: (_, state) {
                            final extra = state.extra as Map<String, dynamic>?;

                            return ShortFormSearchedScreen(
                              searchKeyword:
                                  extra?[GoRouterExtraKeys.searchKeyword]
                                          as String? ??
                                      '',
                              initialPageIndex:
                                  extra?[GoRouterExtraKeys.initialPageIndex]
                                          as int? ??
                                      0,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  name: ShortFormScreen.routeName,
                  builder: (_, __) => const ShortFormScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigationKey,
                      path: 'filter',
                      name: ShortFormFilterScreen.routeName,
                      builder: (_, __) => const ShortFormFilterScreen(),
                    ),
                  ],
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
                    GoRoute(
                      parentNavigatorKey: rootNavigationKey,
                      path: 'profile',
                      name: ProfileScreen.routeName,
                      builder: (_, __) => const ProfileScreen(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'edit-personal-info',
                          name: EditPersonalInfoScreen.routeName,
                          builder: (_, __) => const EditPersonalInfoScreen(),
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'account-deletion',
                          name: AccountDeletionScreen.routeName,
                          builder: (_, __) => const AccountDeletionScreen(),
                        ),
                      ],
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigationKey,
                      path: 'notification',
                      name: NotificationScreen.routeName,
                      builder: (_, __) => const NotificationScreen(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'setting',
                          name: NotificationSettingScreen.routeName,
                          builder: (_, __) => const NotificationSettingScreen(),
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'detail',
                          name: NotificationDetailScreen.routeName,
                          builder: (_, __) => const NotificationDetailScreen(),
                        ),
                        GoRoute(
                          path: 'shortform',
                          name: NotificationShortFormScreen.routeName,
                          builder: (_, __) =>
                              const NotificationShortFormScreen(),
                        ),
                      ],
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigationKey,
                      path: 'info',
                      name: AppInfoScreen.routeName,
                      builder: (_, __) => const AppInfoScreen(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'open-source-licenses',
                          name: OpenSourceLicensesScreen.routeName,
                          builder: (_, __) => const OpenSourceLicensesScreen(),
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigationKey,
                          path: 'official-sns-account',
                          name: OfficialSnsAccountScreen.routeName,
                          builder: (_, __) => const OfficialSnsAccountScreen(),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'my-view-log',
                      name: MyViewLogScreen.routeName,
                      builder: (_, __) => const MyViewLogScreen(),
                      routes: [
                        GoRoute(
                          path: 'shortform',
                          name: MyViewLogShortFormScreen.routeName,
                          builder: (_, state) => MyViewLogShortFormScreen(
                            initialPageIndex: state.extra as int? ?? 0,
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'my-comment-log',
                      name: MyCommentLogScreen.routeName,
                      builder: (_, __) => const MyCommentLogScreen(),
                      routes: [
                        GoRoute(
                          path: 'shortform',
                          name: MyCommentLogShortFormScreen.routeName,
                          builder: (_, state) {
                            final extra = state.extra as Map<String, dynamic>?;

                            return MyCommentLogShortFormScreen(
                              newsId:
                                  extra?[GoRouterExtraKeys.newsId] as int? ??
                                      Constants.unknownErrorId,
                              shortFormUrl:
                                  extra?[GoRouterExtraKeys.shortFormUrl]
                                          as String? ??
                                      Constants.unknownErrorString,
                            );
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'my-reaction-log',
                      name: MyReactionLogScreen.routeName,
                      builder: (_, __) => const MyReactionLogScreen(),
                      routes: [
                        GoRoute(
                          path: 'shortform',
                          name: MyReactionLogShortFormScreen.routeName,
                          builder: (_, state) {
                            final extra = state.extra as Map<String, dynamic>?;

                            return MyReactionLogShortFormScreen(
                              newsId:
                                  extra?[GoRouterExtraKeys.newsId] as int? ??
                                      Constants.unknownErrorId,
                              shortFormUrl:
                                  extra?[GoRouterExtraKeys.shortFormUrl]
                                          as String? ??
                                      Constants.unknownErrorString,
                            );
                          },
                        ),
                      ],
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
          path: '/permission',
          name: PermissionScreen.routeName,
          builder: (_, __) => const PermissionScreen(),
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
        GoRoute(
          path: '/register-agreement',
          name: RegisterAgreementScreen.routeName,
          builder: (_, __) => const RegisterAgreementScreen(),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigationKey,
          path: '/search',
          name: SearchScreen.routeName,
          builder: (_, state) {
            final extra = state.extra as Map<String, dynamic>?;

            return SearchScreen(
              initialSearchKeyword:
                  extra?[GoRouterExtraKeys.searchKeyword] as String?,
            );
          },
        ),
      ];

  void authErrorLogout() {
    ref.read(userInfoProvider.notifier).logout(isAuthErrorLogout: true);
  }

  String? redirectLogic(BuildContext _, GoRouterState state) {
    // 스플래시 화면 또는 접근권한 허용 화면인 경우 리다이렉트 로직 실행하지 않음
    // 스플래시 화면 또는 접근권한 허용 화면에서 자체 로직을 실행하도록 함
    if (state.fullPath == CustomRoutePath.splash ||
        state.fullPath == CustomRoutePath.permission) {
      return null;
    }

    final UserModelBase user = ref.read(userInfoProvider);

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
      if (user.agreedToTerms) {
        // 약관 동의를 한 경우 무조건 회원가입 페이지로 이동
        return state.fullPath != CustomRoutePath.register
            ? CustomRoutePath.register
            : null;
      } else {
        // 약관 동의를 하지 않은 경우 무조건 약관 동의 페이지로 이동
        return state.fullPath != CustomRoutePath.registerAgreement
            ? CustomRoutePath.registerAgreement
            : null;
      }
    }

    // UserModelError
    // 로그인 에러 상태인 경우 무조건 로그인 페이지로 이동
    if (user is UserModelError) {
      return !isLoggingIn ? CustomRoutePath.login : null;
    }

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 RegisterScreen이면
    // 메인화면으로 이동
    // exploration 화면으로 이동하지만, exploration 화면을 initialize만 한 후, home 화면으로 이동하게 됨
    if (user is UserModel) {
      return isLoggingIn || state.fullPath == CustomRoutePath.register
          ? CustomRoutePath.exploration
          : null;
    }

    // GuestUserModel
    // 게스트 유저 정보가 있는 상태고 현재 로그인 화면이라면
    // 메인화면으로 이동
    // exploration 화면으로 이동하지만, exploration 화면을 initialize만 한 후, home 화면으로 이동하게 됨
    if (user is GuestUserModel && isLoggingIn) {
      return CustomRoutePath.exploration;
    }

    return null;
  }
}
