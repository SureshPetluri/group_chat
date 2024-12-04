class UserManagementState{
  List<bool> selectedItems;
  final bool selectAll;
  final bool isGroupPage;
  List<AppCurrentUser> users = [];
  List<Map<String, dynamic>> selectedUsers = [];
  bool isSubmitting;
  bool isGroupCreate;

  UserManagementState({
    this.selectedItems = const [],
    this.selectAll = false,
    this.isGroupPage = false,
    this.users = const [],
    this.selectedUsers = const [],
    this.isSubmitting = false,
    this.isGroupCreate = false,
  });

  UserManagementState copyWith({
    List<bool>? selectedItems,
    bool? selectAll,
    bool? isSubmitting,
    bool? isGroupCreate,
    bool? isGroupPage,
    List<AppCurrentUser>? users,
    List<Map<String, dynamic>>? selectedUsers,
  }) {
    return UserManagementState(
      selectedItems: selectedItems ?? this.selectedItems,
      selectAll: selectAll ?? this.selectAll,
      isGroupPage: isGroupPage ?? this.isGroupPage,
      users: users ?? this.users,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isGroupCreate: isGroupCreate ?? this.isGroupCreate,
    );
  }
}

class AppCurrentUser {
  final String mobile;
  final String name;
  final String email;
  final String userId;
  final bool isVerified;
  final String docId;
  final String profileImageUrl;

  AppCurrentUser(
      {this.mobile = "",
        this.name = "",
        this.email = "",
        this.userId = "",
        this.isVerified = false,
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
      isVerified: firestore.containsKey('isVerified') ? firestore['isVerified'] ?? false : false,
      profileImageUrl: firestore.containsKey('profileImageUrl')
          ? firestore['profileImageUrl'] ?? ""
          : "",
    );
  }
}
