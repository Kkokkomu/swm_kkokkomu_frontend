class SelectedMyViewLogModel {
  final bool isSelectMode;
  final Set<int> selectedLogIds;

  SelectedMyViewLogModel({
    required this.isSelectMode,
    required this.selectedLogIds,
  });

  SelectedMyViewLogModel copyWith({
    bool? isSelectMode,
    Set<int>? selectedLogIds,
  }) =>
      SelectedMyViewLogModel(
        isSelectMode: isSelectMode ?? this.isSelectMode,
        selectedLogIds: selectedLogIds ?? this.selectedLogIds,
      );
}
