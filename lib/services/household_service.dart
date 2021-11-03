import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/models/household_app_user.dart';

class HouseholdService {
  final householdCollection =
      FirebaseFirestore.instance.collection('households');

  Stream<Household> get household {
    return householdCollection.snapshots().map(_householdFromSnapshot);
  }

  Household _householdFromSnapshot(QuerySnapshot snapshot) {
    var household =
        Household.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);

    return household;
  }

  Future<bool> isAlreadyInHousehold(String senderUId) async =>
      await householdCollection
          .where('uIds', arrayContains: senderUId)
          .limit(1)
          .get()
          .then((snapshot) {
        if (snapshot.size == 0) {
          return false;
        } else {
          return true;
        }
      });

  Future createHousehold(List<AppUser> users, String ownerUId) async {
    var householdAppUsers = users
        .map((user) => HouseholdAppUser(
            uid: user.uid,
            fullName: "${user.firstName} ${user.secondName}",
            isOwner: user.uid == ownerUId))
        .toList();

    await householdCollection.doc().set(Household(
            users: householdAppUsers,
            uIds: householdAppUsers.map((appUser) => appUser.uid).toList())
        .toMap());
  }

  Future addToHousehold(AppUser user, String senderUId) async {
    var querySnapshot =
        await householdCollection.where('uIds', arrayContains: senderUId).get();

    var documentId = querySnapshot.docs[0].reference.id;

    var householdAppUser = HouseholdAppUser(
        uid: user.uid,
        fullName: "${user.firstName} ${user.secondName}",
        isOwner: false);

    await householdCollection.doc(documentId).update({
      'users': FieldValue.arrayUnion([householdAppUser.toMap()]),
      'uIds': FieldValue.arrayUnion([user.uid])
    });
  }
}
