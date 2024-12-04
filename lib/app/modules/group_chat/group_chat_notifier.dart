import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/form_utils.dart';
import '../../utils/repository.dart';
import 'group_chat_state.dart';

class GroupChatNotifier extends StateNotifier<GroupChatState> {
  GroupChatNotifier() : super(GroupChatState());

  Future<void> fetchGroups() async {
    try {
      List<GroupModel> groups = [];
      String userId = SignInRepository.getUserId();
      // FormValidations.showProgress();
      state = state.copyWith(isSubmitting:true);
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
      debugPrint('Error fetching user groups: $e');
       // In case of error, return an empty list
    }finally{
      state = state.copyWith(isSubmitting:false);
      // FormValidations.stopProgress();
    }
  }
}

final groupChatProvider =
    StateNotifierProvider<GroupChatNotifier, GroupChatState>(
  (ref) => GroupChatNotifier(),
);
