class LoginState {
  final String email;
  final String password;
  final String resetEmail;
  final bool isForgot;
  final bool obscure;

  LoginState({
    this.email = '',
    this.password = '',
    this.resetEmail = '',
    this.isForgot = false,
    this.obscure = true,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? resetEmail,
    bool? isForgot,
    bool? obscure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      resetEmail: resetEmail ?? this.resetEmail,
      isForgot: isForgot ?? this.isForgot,
      obscure: obscure ?? this.obscure,
    );
  }
}
