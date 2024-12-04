import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/snackbars_widget.dart';
import 'user_management_state.dart';

final userManagementProvider =
    StateNotifierProvider<UserManagementNotifier, UserManagementState>(
  (ref) => UserManagementNotifier(),
);

class UserManagementNotifier extends StateNotifier<UserManagementState> {
  UserManagementNotifier() : super(UserManagementState()) {
    fetchUsers();
    state = state.copyWith(selectAll: false);
  }

  List<Map<String, dynamic>> selectedUsers = [];

  void funcGroup(bool isValue) {
    state = state.copyWith(isGroupPage: isValue);
  }

  void onItemSelected(bool? value, int index) {
    // Create a new list with the updated value at the specified index
    List<bool> updatedItems = state.selectedItems;
    updatedItems[index] = value ?? false;
    // Update the state with the new list
    state = state.copyWith(selectedItems: updatedItems);

    // Update the selectAll flag based on whether all items are selected
    state = state.copyWith(selectAll: updatedItems.every((item) => item));
  }

  void onSelectAllChanged(bool? value) async {
    selectedUsers.clear();
    for (var user in state.users) {
      if (value ?? false) {
        selectedUsers.add({
          "userId": user.userId,
        });
      } else {
        selectedUsers.clear();
      }
    }
    print("selectedUsers...$selectedUsers");
    state = state.copyWith(
        selectedItems: List.generate(20, (index) => (!state.selectAll)));
    state = state.copyWith(selectAll: value ?? false);
  }

  void onDeselectAllChanged(bool? value) {
    selectedUsers.clear();
    state =
        state.copyWith(selectedItems: List.generate(20, (index) => (false)));
    state = state.copyWith(selectAll: value ?? false);
  }

  Future<void> fetchUsers() async {
    try {
      state = state.copyWith(isSubmitting: true);
      // FormValidations.showProgress();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // 'users' collection in Firestore
          .get();
      List<AppCurrentUser> users = snapshot.docs.map((doc) {
        return AppCurrentUser.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      state = state.copyWith(users: users);

      state = state.copyWith(
          selectedItems: List.generate(state.users.length, (index) => false));
    } catch (e) {
      print('Error fetching users: $e');
      // Optionally show an error message or handle empty state
    } finally {
      state = state.copyWith(isSubmitting: false);
      // FormValidations.stopProgress();
    }
  }

  // Handle creating a group with selected users
  Future<void> createGroup(BuildContext context) async {
    state = state.copyWith(selectedUsers: selectedUsers);
    if (state.selectedUsers.isEmpty) {
      // If no users selected, show an alert
      SnackNotification.showCustomSnackBar("Please select at least one user.");
      return;
    }
    print("selectedUsers in a group: ${state.selectedUsers}");
    // Create a new group document in the central 'groups' collection
    try {
      state = state.copyWith(isGroupCreate: true);
      for (var selected in selectedUsers) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(selected['userId'])
            .update({
          'isVerified': true, // Use the same groupId for all users
        });
      }
      onDeselectAllChanged(false);
    } catch (e) {
      print("Error approving User: $e");
    } finally {
      state = state.copyWith(isGroupCreate: false);
      SnackNotification.showCustomSnackBar("Selected User is Approved.");
    }
    // Add the groupId to each user's `groups` collection
  }
}
