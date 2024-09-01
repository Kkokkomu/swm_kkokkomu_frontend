import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/bottom_navigation_bar_state_model.dart';

final bottomNavigationBarStateProvider = StateNotifierProvider.autoDispose<
    BottomNavigationBarStateNotifier, BottomNavigationBarStateModel>(
  (ref) => BottomNavigationBarStateNotifier(),
);

class BottomNavigationBarStateNotifier
    extends StateNotifier<BottomNavigationBarStateModel> {
  BottomNavigationBarStateNotifier()
      : super(
          BottomNavigationBarStateModel(
            isBottomNavigationBarVisible: true,
            isModalBarrierVisible: false,
          ),
        );

  void setBottomNavigationBarVisibility(bool isVisible) {
    // 변경사항이 없는 경우 아무것도 수행하지 않음
    if (state.isBottomNavigationBarVisible == isVisible) return;

    state = state.copyWith(isBottomNavigationBarVisible: isVisible);
  }

  void setModalBarrierVisibility(bool isVisible) {
    // 변경사항이 없는 경우 아무것도 수행하지 않음
    if (state.isModalBarrierVisible == isVisible) return;

    state = state.copyWith(isModalBarrierVisible: isVisible);
  }
}
