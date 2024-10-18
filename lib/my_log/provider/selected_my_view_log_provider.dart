import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/my_log/model/selected_my_view_log_model.dart';

final selectedMyViewLogProvider = StateNotifierProvider.autoDispose<
    SelectedMyViewLogStateNotifier, SelectedMyViewLogModel>(
  (ref) => SelectedMyViewLogStateNotifier(),
);

class SelectedMyViewLogStateNotifier
    extends StateNotifier<SelectedMyViewLogModel> {
  SelectedMyViewLogStateNotifier()
      : super(SelectedMyViewLogModel(isSelectMode: false, selectedLogIds: {}));

  void toggleSelectMode() {
    state.selectedLogIds.clear();
    state = state.copyWith(isSelectMode: !state.isSelectMode);
  }

  void toggleLog(int id) {
    if (state.selectedLogIds.contains(id)) {
      state.selectedLogIds.remove(id);
      state = state.copyWith();
    } else {
      state.selectedLogIds.add(id);
      state = state.copyWith();
    }
  }
}
