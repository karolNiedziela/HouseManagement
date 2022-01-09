import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/models/household_app_user.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/user_service.dart';

class HouseholdService {
  final householdCollection =
      FirebaseFirestore.instance.collection('households');

  Stream<Household> getHousehold(String uid) {
    return householdCollection
        .where('uIds', arrayContainsAny: [uid])
        .snapshots()
        .map(_householdFromSnapshot);
  }

  Household _householdFromSnapshot(QuerySnapshot snapshot) {
    var household =
        Household.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);

    return household;
  }

  Future<List<String>> getUserIds() async {
    var querySnapshot = await householdCollection
        .where('uIds', arrayContains: AuthService().uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return <String>[AuthService().uid!];
    } else {
      return Household.fromMap(querySnapshot.docs[0].data()).uIds;
    }
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

  Future removeFromHouseHold(
      String currentUserUId, String userUIdToRemove) async {
    var querySnapshot = await householdCollection
        .where('uIds', arrayContains: currentUserUId)
        .get();

    var documentId = querySnapshot.docs[0].reference.id;

    if ((querySnapshot.docs[0].get('users') as List).length == 2) {
      await householdCollection.doc(documentId).delete();
      return;
    }

    Map<String, dynamic> userToRemove =
        (querySnapshot.docs[0].get('users') as List)
            .firstWhere((element) => element['uid'] == userUIdToRemove);

    await householdCollection.doc(documentId).update({
      'uIds': FieldValue.arrayRemove([userUIdToRemove]),
      'users': FieldValue.arrayRemove([userToRemove])
    });
  }

  Future leaveHousehold() async {
    final userService = UserService();
    final authService = AuthService();

    var currentUId = authService.uid!;
    await removeFromHouseHold(authService.uid!, authService.uid!);

    await userService.clearAcceptedInvitations(currentUId);
  }
}
