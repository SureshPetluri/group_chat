import 'dart:convert';

import 'package:academic/app/modules/login/login_screen.dart';
import 'package:academic/app/modules/registration/registration_notifier.dart';
import 'package:academic/app/utils/form_utils.dart';
import 'package:academic/app/widgets/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme/color_theme.dart';

class RegistrationPage extends ConsumerWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(registrationFormProvider);
    final formNotifier = ref.read(registrationFormProvider.notifier);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          "Registration",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formNotifier.formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    formNotifier.profileImageUpdate(context);
                  },
                  child: Card(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: formState.imageBase64.isEmpty
                        ? const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.camera_alt))
                        : Image.memory(
                            base64Decode(formState.imageBase64),
                            height: 100,
                            width: 100,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formNotifier.fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  // onChanged: formNotifier.updateFullName,
                  // initialValue: formState.fullName,
                  validator: FormValidations.notEmpty,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formNotifier.mobileController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      labelText: 'Mobile', counterText: ""),
                  keyboardType: TextInputType.phone,
                  // onChanged: formNotifier.updateMobile,
                  // initialValue: formState.mobile,
                  validator: FormValidations.validateMobile,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formNotifier.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  // onChanged: formNotifier.updateEmail,
                  // initialValue: formState.email,
                  validator: FormValidations.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formNotifier.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  // onChanged: formNotifier.updatePassword,
                  // initialValue: formState.password,
                  validator: FormValidations.validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: formNotifier.confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  // onChanged: formNotifier.updateConfirmPassword,
                  // initialValue: formState.confirmPassword,
                  validator: (text) => FormValidations.validateConfirmPassword(
                      formNotifier.passwordController.text.trim(),
                      formNotifier.confirmPasswordController.text.trim()),
                ),
                const SizedBox(height: 16),
                AppButton(
                  onPressed: () {
                    formNotifier.submitForm(context);
                  },
                  titleColor: Colors.black,
                  child: formState.isSubmitting
                      ? const CircularProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            "Register",
                            style: TextStyle(color: blackColor, fontSize: 18),
                          ),
                        ),
                ),

                const SizedBox(height: 16),
                // Forgot Password Button
                formState.isSubmitting
                    ? const SizedBox.shrink()
                    : Text.rich(
                        TextSpan(
                          text: 'Already have an account ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Sign In',
                                style: const TextStyle(color: whiteColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  }),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
