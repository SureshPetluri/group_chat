import 'package:academic/app/modules/registration/registration_notifier.dart';
import 'package:academic/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/form_utils.dart';
import '../login/login_notifier.dart';

class ForgotPasswordBottomSheet extends ConsumerWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);
    final loginNotifier = ref.read(loginStateProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // Email TextFormField for resetting password
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: loginNotifier.formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: loginState.resetEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(labelText: 'Enter your email'),
                  onChanged: (value) => loginNotifier.setResetEmail(value),
                  validator: FormValidations.validateEmail,
                ),
                const SizedBox(height: 16),
                // Reset Button
                /*if (loginState.isForgot) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              counterText: '',
                            ),
                            controller: loginNotifier.textControllers[index],
                            autofocus: index == 0,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            // counterText: '',
                            onChanged: (value) {
                              // Move to the next field if value is not empty
                              if (value.isNotEmpty && index < (3)) {
                                FocusScope.of(context).nextFocus();
                              }
                              // Move back if the field is empty
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            onEditingComplete: () {
                              // Dismiss keyboard
                              FocusScope.of(context).unfocus();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // validators: FormValidations.notEmpty,
                          ),
                        ),
                      );
                    }),
                  ),
                  AppButton(
                    onPressed: () {
                      // Handle reset password logic
                      // For now, just print the reset email
                      loginNotifier.submitForgotPassword(context);
                      print('Reset Email: ${loginState.resetEmail}');
                    },
                    title: 'Submit',
                    titleColor: Colors.black,
                  ),
                ] else*/
                  AppButton(
                    onPressed: () {
                      loginNotifier.submitForgotPassword(context);
                      // Handle reset password logic
                      // For now, just print the reset email
                      print('Reset Email: ${loginState.resetEmail}');
                    },
                    title: 'Submit',
                    titleColor: Colors.black,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
class VerifyOTP extends ConsumerWidget {
  const VerifyOTP({super.key,required this.validationId});
final String validationId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationFormProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: registrationState.formKeyOTP,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          controller: registrationState.textControllers[index],
                          autofocus: index == 0,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          // counterText: '',
                          onChanged: (value) {
                            // Move to the next field if value is not empty
                            if (value.isNotEmpty && index < (3)) {
                              FocusScope.of(context).nextFocus();
                            }
                            // Move back if the field is empty
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onEditingComplete: () {
                            // Dismiss keyboard
                            FocusScope.of(context).unfocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          // validators: FormValidations.notEmpty,
                        ),
                      ),
                    );
                  }),
                ),
                AppButton(
                  onPressed: () {
                    // Handle reset password logic
                    // For now, just print the reset email
                    registrationState.submitOTP(context,validationId);
                    // print('Reset Email: ${loginState.resetEmail}');
                  },
                  title: 'Submit',
                  titleColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
*/
