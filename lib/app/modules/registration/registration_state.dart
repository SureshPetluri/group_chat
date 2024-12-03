class RegistrationFormState {
  final String fullName;
  final String mobile;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isSubmitting;
  final String imageBase64;
  final String imageName;
  final bool isRegCompleted;

  RegistrationFormState({
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.isSubmitting = false,
    this.isRegCompleted = false,
    this.imageBase64 = '',
    this.imageName = '',
  });

  RegistrationFormState copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isSubmitting,
    String? imageBase64,
    String? imageName,
    bool? isRegCompleted,
  }) {
    return RegistrationFormState(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
      isRegCompleted: isRegCompleted ?? this.isRegCompleted,
    );
  }
}
