import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/services/auth_service.dart';

class HouseholdService {
  final AuthService _authService = AuthService();

  final householdCollection =
      FirebaseFirestore.instance.collection('households');

  Stream<Household> get household {
    return householdCollection
        .where('users', arrayContainsAny: [_authService.uid])
        .snapshots()
        .map(_householdFromSnapshot);
  }

  Household _householdFromSnapshot(QuerySnapshot snapshot) {
    var household =
        Household.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);

    return household;
  }

  Future createHousehold(List<String> users, String ownerUId) async {
    await householdCollection
        .doc()
        .set(Household(users: users, ownerUId: ownerUId).toMap());
  }
}
