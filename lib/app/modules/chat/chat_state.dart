class ChatState {
  final String userUid;
  final String groupImage;

  ChatState({
    this.userUid = "",
    this.groupImage = "",
  });

  ChatState copyWith({
    String? userUid,
    String? groupImage,
  }) {
    return ChatState(
      userUid: userUid ?? this.userUid,
      groupImage: groupImage ?? this.groupImage,
    );
  }
}
