class DashBoardState {
  final int selectedIndex;

  DashBoardState({
    this.selectedIndex = 0,

  });

  DashBoardState copyWith({
    int? selectedIndex,
  }) {
    return DashBoardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
