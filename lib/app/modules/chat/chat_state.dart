class ChatState {
  final String groupImage;

  ChatState({
    this.groupImage = "",
  });

  ChatState copyWith({
    String? groupImage,
  }) {
    return ChatState(
      groupImage: groupImage ?? this.groupImage,
    );
  }
}
