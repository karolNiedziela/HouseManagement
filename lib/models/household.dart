import 'package:housemanagement/models/household_app_user.dart';

class Household {
  List<HouseholdAppUser> users = <HouseholdAppUser>[];
  List<String> uIds = <String>[];

  Household({required this.users, required this.uIds});

  factory Household.fromMap(Map<String, dynamic> map) {
    return Household(
        users: (map['users'] as List)
            .map((data) => HouseholdAppUser.fromMap(data))
            .toList(),
        uIds: List.from(map['uIds']));
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users.map((user) => user.toMap()).toList(),
      'uIds': uIds.map((uId) => uId).toList()
    };
  }
}
