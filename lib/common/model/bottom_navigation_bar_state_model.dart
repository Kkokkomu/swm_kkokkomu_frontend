class BottomNavigationBarStateModel {
  final bool isBottomNavigationBarVisible;
  final bool isModalBarrierVisible;

  BottomNavigationBarStateModel({
    required this.isBottomNavigationBarVisible,
    required this.isModalBarrierVisible,
  });

  BottomNavigationBarStateModel copyWith({
    bool? isBottomNavigationBarVisible,
    bool? isModalBarrierVisible,
  }) {
    return BottomNavigationBarStateModel(
      isBottomNavigationBarVisible:
          isBottomNavigationBarVisible ?? this.isBottomNavigationBarVisible,
      isModalBarrierVisible:
          isModalBarrierVisible ?? this.isModalBarrierVisible,
    );
  }
}
