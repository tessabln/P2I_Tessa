enum UserStatus {
  vivant,
  mort,
}

extension UserStatusExtension on UserStatus {
  String get stringValue {
    return toString().split('.').last;
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
  final int nbkills;

  User({
    required this.uid,
    required this.lastname,
    required this.firstname,
    required this.family,
    required this.email,
    required this.targetcode,
    required this.status,
    required this.nbkills,
  });
}
