import 'dart:convert';

import 'package:academic/app/modules/home/home_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/image_picker.dart';
import '../../utils/repository.dart';
import '../../widgets/snackbars_widget.dart';
import '../dash_board/dash_board_notifier.dart';
import '../group_chat/group_chat_state.dart';

final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(),
);

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier() : super(HomeState()) {
    fetchUsers();
    state = state.copyWith(selectAll: false);
  }

  List<Map<String, dynamic>> selectedUsers = [];
  TextEditingController groupNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  profileImageUpdate(
      BuildContext context, String groupId, WidgetRef ref) async {
    try {
      Map<String, dynamic> result =
          await pickImageFromCameraOrGallery(context, [
        'jpg',
        'jpeg',
        'png',
      ]);
      print("result is....${result['base64Image']}");
      state = state.copyWith(
          imageBase64: result['base64Image'], imageName: result['image']);
    } catch (e) {
      SnackNotification.showCustomSnackBar("$e");
    }
  }

  // Function to handle the "Select All" checkbox

  Future<String> _uploadGroupImage(String groupId) async {
    String downloadUrl = "";
    if (state.imageBase64.isEmpty) return downloadUrl;

    try {
      // Define the storage path (e.g., academy/profile/userId)
      String storagePath =
          'academy/group/$groupId/${DateTime.now().millisecondsSinceEpoch}';

      // Upload the image to Firebase Storage
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref(storagePath)
          .putData(base64Decode(state.imageBase64));

      // Get the download URL
      downloadUrl = await uploadTask.ref.getDownloadURL();
      SnackNotification.showCustomSnackBar("Group Profile updated");
      // You can use this URL to display the image anywhere in your app
    } catch (e) {
      SnackNotification.showCustomSnackBar("Error uploading image: $e");
      print("Error uploading image: $e");
    }
    return downloadUrl;
  }

  void onSelectAllChanged(bool? value) async {
    selectedUsers.clear();
    print("SignInRepository... ${SignInRepository.getUserId()}");
    for (var user in state.users) {
      bool presentUser = (SignInRepository.getUserId() == user.userId);
      if (value ?? false) {
        selectedUsers.add({
          "userId": user.userId,
          "docId": user.docId,
          "isGroupAdmin": presentUser,
          "profileName": user.name,
          "profileImage": user.profileImageUrl,
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

  currentUser(int index) {
    state = state.copyWith(currentUserIndex: index);
  }

  // Handle creating a group with selected users
  Future<void> createGroup(
      BuildContext context, WidgetRef ref, String groupId) async {
    if (SignInRepository.getUserId() ==
        state.users[state.currentUserIndex].userId) {
      selectedUsers.add({
        "userId": state.users[state.currentUserIndex].userId,
        'docId': state.users[state.currentUserIndex].docId,
        "isGroupAdmin": true,
        "profileName": state.users[state.currentUserIndex].name,
        "profileImage": state.users[state.currentUserIndex].profileImageUrl,
      });
    }

    if (state.imageBase64.isEmpty) {
      SnackNotification.showCustomSnackBar("Pick Image");
      return;
    }

    state = state.copyWith(selectedUsers: selectedUsers);
    if (state.selectedUsers.isEmpty) {
      // If no users selected, show an alert
      SnackNotification.showCustomSnackBar("Please select at least one user.");
      return;
    }
    try {
      state = state.copyWith(isGroupCreate: true);
      String downloadUrl = await _uploadGroupImage(groupId);
      print("selectedUsers in a group: ${state.selectedUsers}");
      // Create a new group document in the central 'groups' collection
      final groupRef =
          await FirebaseFirestore.instance.collection('groups').add({
        'groupName': groupNameController.text.trim(),
        'groupImageUrl': downloadUrl,
        'members': state.selectedUsers,
      });
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupRef.id)
          .update({
        'groupId': groupRef.id,
      });
      // Add the groupId to each user's `groups` collection
      for (var selected in selectedUsers) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(selected['userId'])
            .collection('groups')
            .add({
          'groupId': groupRef.id, // Use the same groupId for all users
        });
      }
      ref.read(groupImageUrlProvider.notifier).state = downloadUrl;
      onDeselectAllChanged(false);
    } catch (e) {
      print("Error..$e");
    } finally {
      state = state.copyWith(isGroupCreate: false);
    }

    groupNameController.clear();
    ref.read(dashBoardProvider.notifier).onItemSelected(1, ref);
  }
}
