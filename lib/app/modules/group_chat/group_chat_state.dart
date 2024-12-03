import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatState {
  final List<GroupModel> groupMembers;

  GroupChatState({
    this.groupMembers = const [],
  });

  GroupChatState copyWith({
    List<GroupModel>? groupMembers,
  }) {
    return GroupChatState(
      groupMembers: groupMembers ?? this.groupMembers,
    );
  }
}

class GroupModel {
  final String groupName;
  final String groupImageUrl;
  final String groupId;
  final bool isGroupAdmin;
  final List<GroupMembersModel> members;

  const GroupModel(
      {this.groupName = "",
      this.isGroupAdmin = false,
      this.groupImageUrl = '',
      this.groupId = '',
      this.members = const []});

  factory GroupModel.fromFirestore(Map<String, dynamic> firestore) {
    return GroupModel(
      groupName: firestore.containsKey('groupName')
          ? firestore['groupName'] ?? ""
          : "",
      groupId:
          firestore.containsKey('groupId') ? firestore['groupId'] ?? "" : "",
      groupImageUrl: firestore.containsKey('groupImageUrl')
          ? firestore['groupImageUrl'] ?? ""
          : "",
      isGroupAdmin: firestore.containsKey('isGroupAdmin')
          ? firestore['isGroupAdmin'] ?? false
          : false,
      members: firestore.containsKey('members') && firestore['members'] is List
          ? (firestore['members'] as List)
              .map((member) => GroupMembersModel.fromFirestore(
                  member as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class GroupMembersModel {
  final String profileName;
  final String userId;
  final bool isGroupAdmin;
  final String profileImageUrl;

  GroupMembersModel(
      {this.profileName = "",this.isGroupAdmin = false, this.userId = "", this.profileImageUrl = ""});

  // Factory constructor to create User from Firestore document snapshot
  factory GroupMembersModel.fromFirestore(Map<String, dynamic> firestore) {
    return GroupMembersModel(
      profileName: firestore.containsKey('profileName') ? firestore['profileName'] ?? "" : "",
      isGroupAdmin: firestore.containsKey('isGroupAdmin') ? firestore['isGroupAdmin'] ?? "" : "",
      userId: firestore.containsKey('userId') ? firestore['userId'] ?? "" : "",
      profileImageUrl: firestore.containsKey('profileImage')
          ? firestore['profileImage'] ?? ""
          : "",
    );
  }
}
final groupNameProvider = StateProvider<String>((ref) => "");
final groupImageUrlProvider = StateProvider<String>((ref) => "");
final groupIdProvider = StateProvider<String>((ref) => "");
