// login_state.dart
import 'package:academic/app/modules/dash_board/dash_board_notifier.dart';
import 'package:academic/app/modules/dash_board/dash_board_screen.dart';
import 'package:academic/app/modules/profile/profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/repository.dart';
import '../../widgets/snackbars_widget.dart';
import '../group_chat/group_chat_state.dart';
import '../user_management/user_management_screen.dart';
import 'login_state.dart';

// StateNotifier for managing login state
class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier() : super(LoginState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  final textControllers = List.generate(4, (_) => TextEditingController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void setResetEmail(String resetEmail) {
    state = state.copyWith(resetEmail: resetEmail);
  }

  void clear() {
    state = LoginState();
  }

  obscureUpdate() {
    state = state.copyWith(obscure: !state.obscure);
  }

  /*forgotPassword() {
    if (formKey.currentState?.validate() ?? false) {
      state = state.copyWith(isForgot: true);
    }
  }*/

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(
      BuildContext context, WidgetRef ref) async {
    ProviderScope.containerOf(context).refresh(dashBoardProvider);
    SignInRepository.eraseSignInData();

    try {
      // Sign in with email and password
      state = state.copyWith(isSubmitting: true);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      if (userCredential.user != null) {
        if (userCredential.user?.emailVerified ?? false) {
          SignInRepository.setUserId(userCredential.user?.uid ?? "");
          loginFormKey.currentState?.reset();
          state = state.copyWith(
            email: '',
            password: '',
            resetEmail: '',
            isForgot: false,
            obscure: true,
          );

          // ProviderScope.containerOf(context).refresh(profileProvider);
          var userDocument = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid ?? "") // Limit to one document
              .get();
          if (userDocument.exists) {
            // Extract the `isVerified` field
            bool isVerified = userDocument.data()?['isVerified'] ?? false;
            bool isAdmin = userDocument.data()?['isAdmin'] ?? false;

            if (isVerified) {
              ref.read(profileProvider.notifier).fetchAndDisplayUserDetails();
              // Route to the next page

              if (isAdmin) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserManagementScreen()),
                  (Route<dynamic> route) =>
                      false, // This removes all previous routes
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()),
                  (Route<dynamic> route) =>
                      false, // This removes all previous routes
                );
              }
            } else {
              // Show an error if the user is not verified
              SnackNotification.showCustomSnackBar(
                  'We are not verifying your account. Please try again later.');
            }
          }
        } else {
          SnackNotification.showCustomSnackBar(
              "Given email id is not verifiedPlease verify to continue.");
        }
      }
      // Successful login
    } on FirebaseAuthException catch (e) {
      // Handle errors during sign-in
      if (e.code == 'user-not-found') {
        SnackNotification.showCustomSnackBar(
            "No user found for that email id:${state.email}");
      } else if (e.code == 'wrong-password') {
        SnackNotification.showCustomSnackBar("Incorrect password.");
      } else {
        SnackNotification.showCustomSnackBar("Error: ${e.message}");
      }
    } finally {
      ref.watch(groupNameProvider.notifier).state = "";
      ref.watch(groupIdProvider.notifier).state = "";
      ref.watch(groupImageUrlProvider.notifier).state = "";
      state = state.copyWith(isSubmitting: false);
    }
  }

  void _resetPassword(BuildContext context) async {
    String? _message;

    try {
      await auth.sendPasswordResetEmail(email: state.resetEmail);

      _message = 'Password reset email sent! Please check your inbox.';
    } on FirebaseAuthException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = 'An error occurred. Please try again later.';
    } finally {
      Navigator.pop(context);
      SnackNotification.showCustomSnackBar(_message);
    }
  }

  submitForgotPassword(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      // String otp =
      //     textControllers.map((controller) => controller.text.trim()).join('');
      // debugPrint("otp is $otp");

      _resetPassword(context);

      // for (int i = 0; i < textControllers.length; i++) {
      //   textControllers[i].clear();
      // }
    }
  }

  submit(BuildContext context, WidgetRef ref) {
    if (loginFormKey.currentState?.validate() ?? false) {
      signInWithEmailAndPassword(context, ref);
    }
  }
}

// Login StateNotifier provider
final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>(
  (ref) => LoginStateNotifier(),
);
