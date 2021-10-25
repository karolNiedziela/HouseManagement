import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/services/auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<AppUser> getByEmail(String email) async {
    var documentSnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    var map = (documentSnapshot.docs[0].data() as Map<String, dynamic>);

    var appUser = AppUser.fromMap(map);

    return appUser;
  }

  Future<String> getFullName() async {
    var documentSnapshot = await userCollection.doc(_authService.uid).get();
    var map = (documentSnapshot.data() as Map<String, dynamic>);
    var appUser = AppUser.fromMap(map);
    return "${appUser.firstName}  ${appUser.secondName}";
  }

  List<Invitation> _invitationListFromSnapshot(QuerySnapshot snapshot) {
    // return snapshot.docs.map((doc) {
    //   return Invitation(
    //       receiverUId: doc.get('receiverUId') ?? '',
    //       senderUId: doc.get('senderUId') ?? '',
    //       senderFullName: doc.get('senderFullName') ?? '');
    // }).toList();

    var invitations = snapshot.docs.map((doc) {
      return Invitation(
          receiverUId: doc.get('receiverUId') ?? '',
          senderUId: doc.get('senderUId') ?? '',
          senderFullName: doc.get('senderFullName') ?? '');
    }).toList();

    return invitations
        .where((invitation) => invitation.receiverUId == _authService.uid)
        .toList();
  }

  Stream<List<Invitation>> get appUserInvitations {
    return userCollection
        .doc(_authService.uid)
        .collection('invitations')
        .snapshots()
        .map(_invitationListFromSnapshot);
  }

  Future<List<Invitation>> getUserFriendRequests() async {
    var documentSnapshot = await userCollection
        .doc(_authService.uid)
        .collection('invitations')
        .get();
    List<Invitation> invitations = documentSnapshot.docs.map((e) {
      var map = (e.data() as Map<String, dynamic>);
      return Invitation.fromMap(map);
    }).toList();

    return invitations
        .where((invitation) => invitation.receiverUId == _authService.uid)
        .toList();
  }

  Future sendFriendRequest(String receiverEmail) async {
    var receiver = await getByEmail(receiverEmail);
    var currentAppUserUId = _authService.uid!;

    var fullName = await getFullName();

    var invitation = Invitation(
        receiverUId: receiver.uid,
        senderUId: currentAppUserUId,
        senderFullName: "${fullName}");

    await userCollection
        .doc(receiver.uid)
        .collection('invitations')
        .doc()
        .set(invitation.toMap());

    await userCollection
        .doc(currentAppUserUId)
        .collection('invitations')
        .doc()
        .set(invitation.toMap());
  }
}
