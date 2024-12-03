// login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../utils/form_utils.dart';
import '../../utils/showModelBottomSheet.dart';
import '../../utils/theme/color_theme.dart';
import '../../widgets/app_button.dart';
import '../forgot/forgot_screen.dart';
import '../group_chat/group_chat_state.dart';
import '../registration/registration_screen.dart';
import 'login_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ref.watch(groupNameProvider.notifier).state = "";
    ref.watch(groupIdProvider.notifier).state = "";
    ref.watch(groupImageUrlProvider.notifier).state = "";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current state from the provider
    final loginState = ref.watch(loginStateProvider);
    final loginStateNotifier = ref.read(loginStateProvider.notifier);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
          backgroundColor: appBarColor,
          foregroundColor: appBarColor,
          surfaceTintColor: appBarColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Login',
            style: TextStyle(color: whiteColor),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: loginStateNotifier.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email TextFormField
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: loginState.email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: FormValidations.validateEmail,
                onChanged: (value) =>
                    ref.read(loginStateProvider.notifier).setEmail(value),
              ),
              const SizedBox(height: 16),
              // Password TextFormField
              TextFormField(
                initialValue: loginState.password,
                keyboardType: TextInputType.visiblePassword,
                validator: FormValidations.validatePassword,
                decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          ref.read(loginStateProvider.notifier).obscureUpdate();
                        },
                        icon: Icon((!loginState.obscure)
                            ? Icons.visibility
                            : Icons.visibility_off))),
                obscureText: loginState.obscure,
                onChanged: (value) =>
                    ref.read(loginStateProvider.notifier).setPassword(value),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                  child: AppButton(
                    height: 20,
                    titlePadding: EdgeInsets.zero,
                    onPressed: () {
                      buildShowModalBottomSheet(
                          context, const ForgotPasswordBottomSheet());
                    },
                    isTextBtn: true,
                    titleFontSize: 12,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // SignIn Button
              AppButton(
                btnBackgroundColor: Colors.white,
                onPressed: () {
                  // Handle sign-in logic
                  // For now, just print the entered values
                  loginStateNotifier.submit(context, ref);
                  print(
                      'Email: ${loginState.email}, Password: ${loginState.password}');
                },
                titleFontSize: 16,
                title: "Sign In",
                titleColor: Colors.black,
              ),

              const SizedBox(height: 16),
              // Forgot Password Button
              Text.rich(
                TextSpan(
                  text: 'New to $App_Name? ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'Register',
                        style: const TextStyle(color: whiteColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
