class HomeState {
  List<bool> selectedItems;
  final bool selectAll;
  final bool isGroupPage;
  List<AppCurrentUser> users = [];
  List<Map<String, dynamic>> selectedUsers = [];
  String imageBase64;
  String imageName;

  HomeState({
    this.selectedItems = const [],
    this.selectAll = false,
    this.isGroupPage = false,
    this.users = const [],
    this.selectedUsers = const [],
    this.imageBase64 = '',
    this.imageName = '',
  });

  HomeState copyWith({
    List<bool>? selectedItems,
    bool? selectAll,
    bool? isGroupPage,
    String? imageBase64,
    String? imageName,
    List<AppCurrentUser>? users,
    List<Map<String, dynamic>>? selectedUsers,
  }) {
    return HomeState(
      selectedItems: selectedItems ?? this.selectedItems,
      selectAll: selectAll ?? this.selectAll,
      isGroupPage: isGroupPage ?? this.isGroupPage,
      users: users ?? this.users,
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
      selectedUsers: selectedUsers ?? this.selectedUsers,
    );
  }
}

class AppCurrentUser {
  final String mobile;
  final String name;
  final String email;
  final String userId;
  final String docId;
  final String profileImageUrl;

  AppCurrentUser(
      {this.mobile = "",
      this.name = "",
      this.email = "",
      this.userId = "",
      this.docId = "",
      this.profileImageUrl = ""});

  // Factory constructor to create User from Firestore document snapshot
  factory AppCurrentUser.fromFirestore(Map<String, dynamic> firestore) {
    return AppCurrentUser(
      mobile: firestore.containsKey('mobile') ? firestore['mobile'] ?? "" : "",
      name: firestore.containsKey('name') ? firestore['name'] ?? "" : "",
      email: firestore.containsKey('email') ? firestore['email'] ?? "" : "",
      docId: firestore.containsKey('docId') ? firestore['docId'] ?? "" : "",
      userId: firestore.containsKey('userId') ? firestore['userId'] ?? "" : "",
      profileImageUrl: firestore.containsKey('profileImageUrl')
          ? firestore['profileImageUrl'] ?? ""
          : "",
    );
  }
}
