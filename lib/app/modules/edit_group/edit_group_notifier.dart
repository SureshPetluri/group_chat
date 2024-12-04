import 'dart:convert';

import 'package:academic/app/modules/group_chat/group_chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/image_picker.dart';
import '../../utils/repository.dart';
import '../../widgets/snackbars_widget.dart';
import 'edit_group_state.dart';

class EditGroupNotifier extends StateNotifier<EditGroupState> {
  EditGroupNotifier() : super(EditGroupState());



  GroupModel listOfMembers = const GroupModel();

  getGroupDetails(WidgetRef ref) {
    // if (ref.read(groupChatProvider).groupMembers.isEmpty) {
    //   ref.read(groupChatProvider.notifier).fetchGroups();
    // } else {
    //   listOfMembers = ref.read(groupChatProvider).groupMembers[0].members;
    // }
    fetchGroups(ref);
  }

  Future<void> fetchGroups(WidgetRef ref) async {
    try {
      // Fetch the group document using the groupId from the provider
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(SignInRepository.getUserId())
          .collection('groups')
          .doc(ref.watch(groupIdProvider.notifier).state)  // Fetch groupId from provider
          .get();

      // Check if the document exists
      if (!snapshot.exists) {
        print("Group document does not exist.");
        return;
      }

      // Get the data from the document
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Convert the data to GroupModel
      GroupModel group = GroupModel.fromFirestore(data);
      print("GroupModel: ${group.isGroupAdmin}");

      // Update state with the group data
      state = state.copyWith(groupMembers: group);

    } catch (e) {
      print('Error fetching group: $e');
      // Optionally show an error message or handle empty state
    }
  }

}

final editGroupProvider =
    StateNotifierProvider<EditGroupNotifier, EditGroupState>(
  (ref) => EditGroupNotifier(),
);
