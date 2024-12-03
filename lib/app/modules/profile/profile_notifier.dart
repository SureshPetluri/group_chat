import 'package:academic/app/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/snackbars_widget.dart';
import '../login/login_screen.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) {
    // if (state.name.isEmpty && state.email.isEmpty) {
      fetchAndDisplayUserDetails();
    // }
  }

  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  ExpansionTileController expansionLogoutController = ExpansionTileController();
  ExpansionTileController expansionAddressController =
      ExpansionTileController();

  logoutExpand(bool isExpand) {
    expansionLogoutController.collapse();
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      // Get the current user's UID, check if the user is logged in
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If no user is logged in, return null
        print("No user is currently signed in.");
        return null;
      }

      String userId = user.uid;

      // Fetch user data from Firestore based on userId
      var userDocument = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .limit(1) // Limit to one document
          .get();
      state = state.copyWith(docId: userDocument.docs.first.id);
      print("Error fetching user details: $userDocument");
      // Return the first document's data if it exists, otherwise null
      return userDocument.docs.isNotEmpty ? userDocument.docs.first.data() : {};
    } catch (e) {
      print("Error fetching user details: $e");
      return {};
    }
  }

  updateAddress(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (state.docId.isNotEmpty) {
      await firestore.collection('users').doc(state.docId).update({
        'updatedAt': Timestamp.now(),
        'address': {
          'street': streetController.text.trim(),
          'city': stateController.text.trim(),
          'state': stateController.text.trim(),
          'postalCode': postalCodeController.text.trim(),
        },
      });
      fetchAndDisplayUserDetails();
      SnackNotification.showCustomSnackBar('Address Added');
      expansionAddressController.collapse();
    } else {
      SnackNotification.showCustomSnackBar('Please try again after some Time');
    }
  }

  void fetchAndDisplayUserDetails() async {
    Map<String, dynamic>? userDetails = await getUserDetails();

    // ProviderScope.containerOf(context).refresh(profileProvider);

    if (userDetails != null) {
      state = state.copyWith(
          name: "${userDetails['name'] ?? "Add Name"}",
          mobile: "${userDetails['mobile'] ?? "Mobile"}",
          profileImageUrl: "${userDetails['profileImageUrl'] ?? ""}",
          email: "${userDetails['email'] ?? "Email"}");

      if (userDetails['address'] != null) {
        state = state.copyWith(
            street: "${userDetails['address']["street"] ?? ""}",
            city: "${userDetails['address']["city"] ?? ""}",
            state: "${userDetails['address']["state"] ?? ""}",
            postalCode: "${userDetails['address']["postalCode"] ?? ""}");
        ProfileState(
            name: "${userDetails['name'] ?? "Add Name"}",
            email: "${userDetails['email'] ?? "Email"}",
            mobile: "${userDetails['mobile'] ?? "Mobile"}",
            profileImageUrl: "${userDetails['profileImageUrl'] ?? ""}",
            street: "${userDetails['address']["street"] ?? ""}",
            city: "${userDetails['address']["city"] ?? ""}",
            state: "${userDetails['address']["state"] ?? ""}",
            postalCode: "${userDetails['address']["postalCode"] ?? ""}");
        stateController.text = state.street;
        cityController.text = state.street;
        streetController.text = state.street;
        postalCodeController.text = state.street;
      }
    } else {
      print("User not found!");
    }
  }

  logOut(BuildContext context) {
    FirebaseMethods.logOut(context);
    // ProviderScope.containerOf(context).dispose();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Remove all routes
    );
    expansionLogoutController.collapse();
    SnackNotification.showCustomSnackBar("Signed out");
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
