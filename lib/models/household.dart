class Household {
  List<String> users = <String>[];
  String ownerUId;

  Household({required this.users, required this.ownerUId});

  factory Household.fromMap(Map<String, dynamic> map) {
    return Household(
        users: List<String>.from(map['users']), ownerUId: map['ownerUId']);
  }

  Map<String, dynamic> toMap() {
    return {'users': users.map((user) => user).toList(), 'ownerUId': ownerUId};
  }
}
