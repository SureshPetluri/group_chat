class ProfileState {
  final bool no;
  final String profileImageUrl;
  final String name;
  final String email;
  final String mobile;
  final String docId;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  // final bool isLogoutExpand;

  ProfileState({
    this.no = false,
    this.name = "Add Name",
    this.profileImageUrl = "",
    this.email = "Email",
    this.mobile = "Mobile",
    this.docId = "",
    this.street = "",
    this.city = "",
    this.state = "",
    this.postalCode = "",
    // this.isLogoutExpand = false,
  });

  ProfileState copyWith({
    bool? no,
    String? name,
    String? profileImageUrl,
    String? email,
    String? mobile,
    String? docId,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    // bool? isLogoutExpand,
  }) {
    return ProfileState(
      no: no ?? this.no,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      docId: docId ?? this.docId,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      // isLogoutExpand: isLogoutExpand ?? this.isLogoutExpand,
    );
  }
}
