import 'dart:convert';

import 'package:academic/app/modules/login/login_screen.dart';
import 'package:academic/app/modules/registration/registration_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/image_picker.dart';
import '../../widgets/snackbars_widget.dart';

class RegistrationFormNotifier extends StateNotifier<RegistrationFormState> {
  RegistrationFormNotifier() : super(RegistrationFormState());
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyOTP = GlobalKey<FormState>();

  /*void updateFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void updateMobile(String value) {
    state = state.copyWith(mobile: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }*/

  Future<void> submitForm(BuildContext context) async {
    // Dummy validation and submission process
    if (formKey.currentState?.validate() ?? false) {
      // if (_validateForm()) {
      await registerUser(context);
      // await sendVerificationCode(state.mobile, context);
      // buildShowModalBottomSheet(context, const VerifyOTP());

      // Open the Modal Bottom Sheet on success
    } else {
      // state = state.copyWith(errorMessage: 'Please correct the errors');
      // }
    }
  }

  /*bool _validateForm() {
    // Basic validation logic
    if (state.fullName.isEmpty ||
        state.mobile.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty ||
        state.password != state.confirmPassword) {
      return false;
    }
    return true;
  }*/

  final textControllers = List.generate(4, (_) => TextEditingController());

/*
  submitOTP(BuildContext context, String validationId) {
    if (formKeyOTP.currentState?.validate() ?? false) {
      String otp =
          textControllers.map((controller) => controller.text.trim()).join('');
      debugPrint("otp is $otp");

      // _verifyOTP(validationId,otp,context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false, // This removes all previous routes
      );
      for (int i = 0; i < textControllers.length; i++) {
        textControllers[i].clear();
      }
    }
  }
*/

  profileImageUpdate(BuildContext context) async {
    Map<String, dynamic> result = await pickImageFromCameraOrGallery(context, [
      'jpg',
      'jpeg',
      'png',
    ]);
    print("result is....${result['base64Image']}");
    state = state.copyWith(imageBase64: result['base64Image']);
    state = state.copyWith(imageName: result['image']);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  registerUser(BuildContext context) async {
    if (state.imageBase64.isEmpty) {
      SnackNotification.showCustomSnackBar("Pick your image");
      return;
    }
    try {
      state = state.copyWith(isSubmitting: true);
      // Step 1: Create user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        String downloadUrl = await _uploadImage(user.uid);
        if (state.isRegCompleted) {
          final docRefId =
              await _firestore.collection('users').doc(user.uid).set({
            'name': fullNameController.text.trim(),
            'mobile': mobileController.text.trim(),
            'email': emailController.text.trim(),
            'userId': user.uid,
            'isVerified': false,
            'isAdmin': false,
            'createdAt': Timestamp.now(),
            'profileImageUrl': downloadUrl,
          });
        }

      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase auth errors
      SnackNotification.showCustomSnackBar(
          e.message ?? "An error occurred during registration.");
    } catch (e) {
      // Handle other errors
      SnackNotification.showCustomSnackBar(
          "An error occurred. Please try again.");
    } finally {
      state = state.copyWith(isSubmitting: false);
      if (state.isRegCompleted) {
        state = state.copyWith(
          isSubmitting: false,
          imageBase64: "",
          imageName: "",
          isRegCompleted: false,
        );
        formKey.currentState?.reset();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false, // This removes all previous routes
        );
        // Show success message
        SnackNotification.showCustomSnackBar(
            "Registration successful! We have sent a verification email. Please verify your email and proceed to login");
      }
    }
  }

  Future<String> _uploadImage(String userId) async {
    String downloadUrl = "";
    if (state.imageBase64.isEmpty) return downloadUrl;

    try {
      // Define the storage path (e.g., academy/profile/userId)
      String storagePath =
          'academy/profile/$userId/${DateTime.now().millisecondsSinceEpoch}';

      // Upload the image to Firebase Storage
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref(storagePath)
          .putData(base64Decode(state.imageBase64));

      // Get the download URL
      downloadUrl = await uploadTask.ref.getDownloadURL();
      state = state.copyWith(isRegCompleted: true);

      // You can use this URL to display the image anywhere in your app
    } catch (e) {
      SnackNotification.showCustomSnackBar("Error uploading image: $e");
    }
    return downloadUrl;
  }

}

final registrationFormProvider =
    StateNotifierProvider<RegistrationFormNotifier, RegistrationFormState>(
  (ref) => RegistrationFormNotifier(),
);
