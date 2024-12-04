class LoginState {
  final String email;
  final String password;
  final String resetEmail;
  final bool isForgot;
  final bool obscure;
  final bool isSubmitting;


  LoginState({
    this.email = '',
    this.password = '',
    this.resetEmail = '',
    this.isForgot = false,
    this.obscure = true,
    this.isSubmitting = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? resetEmail,
    bool? isForgot,
    bool? obscure,
    bool? isSubmitting,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      resetEmail: resetEmail ?? this.resetEmail,
      isForgot: isForgot ?? this.isForgot,
      obscure: obscure ?? this.obscure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
