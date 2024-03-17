enum UserStatus {
  vivant,
  mort,
}

extension UserStatusExtension on UserStatus {
  String get stringValue {
    return this.toString().split('.').last;
  }

  static UserStatus fromString(String status) {
    return UserStatus.values.firstWhere(
      (element) => element.stringValue == status,
      orElse: () => UserStatus.vivant,
    );
  }
}


class User {
  final String uid;
  final String lastname;
  final String firstname;
  final String family;
  final String email;
  final int targetcode;
  final UserStatus status; 

  User({
    required this.uid,
    required this.lastname,
    required this.firstname,
    required this.family,
    required this.email,
    required this.targetcode,
    required this.status, 
  });
}