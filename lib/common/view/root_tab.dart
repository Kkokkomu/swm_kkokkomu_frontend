import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/root_tab_scaffold_key_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/component/exploration_screen_drawer.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';
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
        // 홈(숏폼) 화면은 다크 모드이므로 상태바 아이콘을 밝게 처리
        // 나머지는 라이트 모드이므로 상태바 아이콘을 어둡게 처리
        statusBarBrightness: navigationShell.currentIndex == 1
            ? Brightness.light
            : Brightness.dark,
        scaffoldKey: scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: navigationShell.currentIndex == 0
            ? const ExplorationScreenDrawer()
            : null,
        bottomNavigationBar: CustomBottomNavigationBar(
          navigationShell: navigationShell,
        ),
        backgroundColor: navigationShell.currentIndex == 1
            ? Colors.black
            : ColorName.white000,
        child: navigationShell,
      ),
    );
  }
}

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNavigationBar({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends ConsumerState<CustomBottomNavigationBar> {
  late final bool isHomeScreen;

  @override
  void initState() {
    super.initState();
    isHomeScreen = widget.navigationShell.currentIndex == 1;
  }

  void refreshCurrentTab(RootTabBottomNavigationBarType tabType) {
    final user = ref.read(userInfoProvider);

    switch (tabType) {
      case RootTabBottomNavigationBarType.exploration:
        break;
      case RootTabBottomNavigationBarType.home:
        if (user is UserModel) {
          ref
              .read(loggedInUserShortFormProvider.notifier)
              .paginate(forceRefetch: true);
        }
        if (user is GuestUserModel) {
          ref
              .read(guestUserShortFormProvider.notifier)
              .paginate(forceRefetch: true);
        }
        break;
      case RootTabBottomNavigationBarType.myPage:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    // 홈(숏폼) 화면에서 감정표현 모달이 열려있을 때 시스템 바텀 네비게이션 바를 어둡게 처리 (안드로이드)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor:
              isHomeScreen && bottomNavigationBarState.isModalBarrierVisible
                  ? Constants.modalBarrierColor
                  : Colors.transparent,
        ),
      );
    });

    return SizedBox(
      // 홈(숏폼) 화면에서 댓글 창이 활성화 되어있을 때 바텀 네비게이션 바를 숨김
      height:
          !isHomeScreen || bottomNavigationBarState.isBottomNavigationBarVisible
              ? Constants.bottomNavigationBarHeightWithSafeArea
              : 0.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              // 현재 탭을 누르면 현재 탭 새로고침
              if (index == widget.navigationShell.currentIndex) {
                // 새로고침 로직 작동
                refreshCurrentTab(RootTabBottomNavigationBarType.values[index]);
                // 현재 탭에 여러 페이지가 nested 되어 있을 경우 초기 페이지로 이동
                widget.navigationShell.goBranch(index, initialLocation: true);
                return;
              }
              // 다른 탭을 누르면 해당 탭으로 이동
              widget.navigationShell.goBranch(index);
            },
            currentIndex: widget.navigationShell.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.electric_bolt),
                label: 'ShortForm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Page',
              ),
            ],
          ),
          // 홈(숏폼) 화면에서 감정표현 모달이 열려있을 때 바텀 네비게이션 바를 어둡게 처리
          if (isHomeScreen && bottomNavigationBarState.isModalBarrierVisible)
            const ModalBarrier(
              color: Constants.modalBarrierColor,
              dismissible: false,
            ),
        ],
      ),
    );
  }
}
