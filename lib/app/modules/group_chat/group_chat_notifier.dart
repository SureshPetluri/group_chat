import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'group_chat_state.dart';

class GroupChatNotifier extends StateNotifier<GroupChatState> {
  GroupChatNotifier() : super(GroupChatState()) {
    // fetchGroups();
  }
  String getUserId() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is logged in, return null
      print("No user is currently signed in.");
      return "";
    }

    return user.uid;
  }

  /*Future<void> fetchGroups() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If no user is logged in, return null
        print("No user is currently signed in.");
        return null;
      }

      String userId = user.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('groups') // 'users' collection in Firestore
          .get();

      // Convert the snapshot to a list of users and update state
      print("snapshot,....${userId}");
      List<GroupModel> users = snapshot.docs.map((doc) {
        return GroupModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      state = state.copyWith(groupMembers: users);
    } catch (e) {
      print('Error fetching users: $e');
      // Optionally show an error message or handle empty state
    }
  }*/
  Future<void> fetchGroups() async {
    try {
      List<GroupModel> groups = [];
      String userId = getUserId();
      // Fetching all group references for the user from their 'groups' collection
      QuerySnapshot groupsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('groups')
          .get();
      // Initialize a list to hold all group data
      // Loop through each group reference
      for (var groupDoc in groupsSnapshot.docs) {
        String groupId = groupDoc['groupId'];  // Get the groupId from the user's group reference

        // Fetch group details from the 'groups' collection using the groupId
        DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .get();
        if (groupSnapshot.exists) {
          // Create a map to store the group data
          // Add the group data to the list
          groups.add(GroupModel.fromFirestore(groupSnapshot.data() as Map<String, dynamic>));


        }
      }
      state = state.copyWith(groupMembers: groups);
      // Return the list of all groups with member details
    } catch (e) {
      print('Error fetching user groups: $e');
       // In case of error, return an empty list
    }
  }
}

final groupChatProvider =
    StateNotifierProvider<GroupChatNotifier, GroupChatState>(
  (ref) => GroupChatNotifier(),
);
