class RegistrationFormState {
  final bool isSubmitting;
  final String imageBase64;
  final String imageName;
  final bool isRegCompleted;

  RegistrationFormState({
    this.isSubmitting = false,
    this.isRegCompleted = false,
    this.imageBase64 = '',
    this.imageName = '',
  });

  RegistrationFormState copyWith({

    bool? isSubmitting,
    String? imageBase64,
    String? imageName,
    bool? isRegCompleted,
  }) {
    return RegistrationFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
      isRegCompleted: isRegCompleted ?? this.isRegCompleted,
    );
  }
}
