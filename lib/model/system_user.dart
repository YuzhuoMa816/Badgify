class SystemUser {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  DateTime? creationTime;
  String? title;

  SystemUser({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.creationTime,
    this.title,
  });

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, creationTime: $creationTime, title: $title)';
  }
}
