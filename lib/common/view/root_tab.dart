import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/root_tab_scaffold_key_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_screen_drawer.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/exploration_screen_scroll_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class RootTab extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const RootTab({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(rootTabScaffoldKeyProvider);

    // 현재 라우트 경로를 가져온 후, 숏폼 화면 인지 확인
    final routePath = navigationShell.shellRouteContext.routerState.fullPath;
    final isShortFormScreen = routePath == CustomRoutePath.home ||
        routePath == CustomRoutePath.explorationShortForm;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
          scaffoldKey.currentState?.closeDrawer();
          return;
        }

        // 드로어가 열려있지 않은 경우 앱 종료 다이얼로그를 띄움
        showAppExitDialog(context);
      },
      child: DefaultLayout(
        // 숏폼 화면은 다크 모드이므로 상태바 아이콘을 밝게 처리
        // 나머지는 라이트 모드이므로 상태바 아이콘을 어둡게 처리
        statusBarBrightness:
            isShortFormScreen ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isShortFormScreen ? ColorName.gray600 : ColorName.white000,
        systemNavigationBarIconBrightness:
            isShortFormScreen ? Brightness.light : Brightness.dark,
        scaffoldKey: scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: navigationShell.currentIndex == 0
            ? const ExplorationScreenDrawer()
            : null,
        bottomNavigationBar: CustomBottomNavigationBar(
          navigationShell: navigationShell,
          isShortFormScreen: isShortFormScreen,
        ),
        // 숏폼 화면은 다크 모드이므로 배경색을 어둡게 처리
        backgroundColor: isShortFormScreen ? Colors.black : ColorName.white000,
        child: navigationShell,
      ),
    );
  }
}

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final bool isShortFormScreen;

  const CustomBottomNavigationBar({
    super.key,
    required this.navigationShell,
    required this.isShortFormScreen,
  });

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  void refreshCurrentTab(RootTabBottomNavigationBarType tabType) {
    final user = ref.read(userInfoProvider);

    switch (tabType) {
      case RootTabBottomNavigationBarType.exploration:
        final scrollController =
            ref.read(explorationScreenScrollControllerProvider);
        if (!scrollController.hasClients) {
          // 만약 스크롤 컨트롤러가 스크롤뷰에 연결되어있지 않으면 스크롤을 조정하지 않음
          return;
        }

        // 스크롤 컨트롤러가 스크롤뷰에 연결되어있으면 스크롤을 맨 위로 이동
        scrollController.animateTo(
          0.0,
          duration: AnimationDuration.scrollToTopAnimationDuration,
          curve: Curves.easeInOut,
        );
        return;

      case RootTabBottomNavigationBarType.home:
        if (user is UserModel) {
          ref
              .read(loggedInUserHomeShortFormProvider.notifier)
              .paginate(forceRefetch: true);
        }
        if (user is GuestUserModel) {
          ref
              .read(guestUserHomeShortFormProvider.notifier)
              .paginate(forceRefetch: true);
        }
        return;

      case RootTabBottomNavigationBarType.myPage:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    // 숏폼 화면에서 감정표현 모달이 상태에 따라
    // 시스템 바텀 네비게이션 바 색상을 변경 (안드로이드)
    if (widget.isShortFormScreen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor:
                  bottomNavigationBarState.isModalBarrierVisible
                      ? Constants.modalBarrierColor
                      : ColorName.gray600,
            ),
          );
        },
      );
    }

    return SizedBox(
      // 숏폼 화면에서 댓글 창이 활성화 되어있을 때 바텀 네비게이션 바를 숨김
      height: !widget.isShortFormScreen ||
              bottomNavigationBarState.isBottomNavigationBarVisible
          ? Constants.bottomNavigationBarHeightWithSafeArea
          : 0.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: widget.isShortFormScreen
                        ? ColorName.gray500
                        : ColorName.gray100,
                    width: 0.5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: (int index) {
                  // 현재 탭을 누르면 현재 탭 새로고침
                  if (index == widget.navigationShell.currentIndex) {
                    // 새로고침 로직 작동
                    refreshCurrentTab(
                        RootTabBottomNavigationBarType.values[index]);
                    // 현재 탭에 여러 페이지가 nested 되어 있을 경우 초기 페이지로 이동
                    widget.navigationShell
                        .goBranch(index, initialLocation: true);
                    return;
                  }
                  // 다른 탭을 누르면 해당 탭으로 이동
                  widget.navigationShell.goBranch(index);
                },
                currentIndex: widget.navigationShell.currentIndex,
                unselectedLabelStyle: CustomTextStyle.detail2Reg(
                  color: widget.isShortFormScreen
                      ? ColorName.gray300
                      : ColorName.gray200,
                ),
                unselectedItemColor: widget.isShortFormScreen
                    ? ColorName.gray300
                    : ColorName.gray200,
                selectedLabelStyle: CustomTextStyle.detail2Reg(
                  color: widget.isShortFormScreen
                      ? ColorName.white000
                      : ColorName.gray600,
                ),
                selectedItemColor: widget.isShortFormScreen
                    ? ColorName.white000
                    : ColorName.gray600,
                backgroundColor: widget.isShortFormScreen
                    ? ColorName.gray600
                    : ColorName.white000,
                elevation: 0.0,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviSearchEnabled.svg()
                        : Assets.icons.svg.icLightnaviSearchEnabled.svg(),
                    icon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviSearchDisabled.svg()
                        : Assets.icons.svg.icLightnaviSearchDisabled.svg(),
                    label: '탐색',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviHomeEnabled.svg()
                        : Assets.icons.svg.icLightnaviHomeEnabled.svg(),
                    icon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviHomeDisabled.svg()
                        : Assets.icons.svg.icLightnaviHomeDisabled.svg(),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviMyEnabled.svg()
                        : Assets.icons.svg.icLightnaviMyEnabled.svg(),
                    icon: widget.isShortFormScreen
                        ? Assets.icons.svg.icNaviMyDisabled.svg()
                        : Assets.icons.svg.icLightnaviMyDisabled.svg(),
                    label: '마이',
                  ),
                ],
              ),
            ),
          ),
          // 숏폼 화면에서 감정표현 모달이 열려있을 때 바텀 네비게이션 바를 어둡게 처리
          if (widget.isShortFormScreen &&
              bottomNavigationBarState.isModalBarrierVisible)
            const ModalBarrier(
              color: Constants.modalBarrierColor,
              dismissible: false,
            ),
        ],
      ),
    );
  }
}
