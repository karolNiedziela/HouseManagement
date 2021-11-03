class HouseholdAppUser {
  String uid;
  String fullName;
  bool isOwner;

  HouseholdAppUser(
      {required this.uid, required this.fullName, required this.isOwner});

  factory HouseholdAppUser.fromMap(Map<String, dynamic> map) {
    return HouseholdAppUser(
        uid: map['uid'], fullName: map['fullName'], isOwner: map['isOwner']);
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'fullName': fullName, 'isOwner': isOwner};
  }
}
