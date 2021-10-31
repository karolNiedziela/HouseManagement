class AppUser {
  String uid;
  String? email;
  String? firstName;
  String? secondName;

  AppUser({required this.uid, this.email, this.firstName, this.secondName});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}
