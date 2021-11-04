import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/household_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final HouseholdService _householdService = HouseholdService();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<AppUser> getByUId(String? uId) async {
    if (uId == null) {
      return await userCollection.doc(_authService.uid).get().then(
          (value) => AppUser.fromMap(value.data() as Map<String, dynamic>));
    }
    return await userCollection
        .doc(uId)
        .get()
        .then((value) => AppUser.fromMap(value.data() as Map<String, dynamic>));
  }

  Future<AppUser> getByEmail(String email) async {
    var documentSnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    var map = (documentSnapshot.docs[0].data() as Map<String, dynamic>);

    var appUser = AppUser.fromMap(map);

    return appUser;
  }

  Stream<List<Invitation>> get appUserInvitations {
    return userCollection
        .doc(_authService.uid)
        .collection('invitations')
        .where('invitationStatus', isEqualTo: InvitationStatus.none.index)
        .snapshots()
        .map(_invitationListFromSnapshot);
  }

  List<Invitation> _invitationListFromSnapshot(QuerySnapshot snapshot) {
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

  Future<List<Invitation>> getUserFriendRequests() async {
    var documentSnapshot = await userCollection
        .doc(_authService.uid)
        .collection('invitations')
        .where('invitationStatus', isEqualTo: InvitationStatus.none.index)
        .get();
    List<Invitation> invitations = documentSnapshot.docs.map((e) {
      var map = e.data();
      return Invitation.fromMap(map);
    }).toList();

    return invitations
        .where((invitation) => invitation.receiverUId == _authService.uid)
        .toList();
  }

  Future sendFriendRequest(String receiverEmail) async {
    var receiver = await getByEmail(receiverEmail);
    var currentAppUserUId = _authService.uid!;
    var sender = await getByUId(currentAppUserUId);

    if (await _householdService.isAlreadyInHousehold(_authService.uid!)) {
      return "${sender.firstName} ${sender.secondName} jest już w grupie domowej.";
    }

    if (await _householdService.isAlreadyInHousehold(receiver.uid)) {
      return "${receiver.firstName} ${receiver.secondName} jest już w grupie domowej.";
    }

    var invitations = await getUserFriendRequests();
    if (invitations.any((invitation) =>
        invitation.receiverUId == receiver.uid ||
        invitation.senderUId == receiver.uid)) {
      return "Już wysłałeś zaproszenie.";
    }

    var fullname = "${sender.firstName} ${sender.secondName}";

    var invitation = Invitation(
        receiverUId: receiver.uid,
        senderUId: currentAppUserUId,
        senderFullName: fullname);

    await userCollection
        .doc(receiver.uid)
        .collection('invitations')
        .doc()
        .set(invitation.toMap());
  }

  Future<bool> canSendFriendRequest(String receiverEmail) async {
    var receiver = await getByEmail(receiverEmail);

    if (await _householdService.isAlreadyInHousehold(_authService.uid!)) {
      // return "${sender.firstName} ${sender.secondName} is already in household.";
      return false;
    }

    if (await _householdService.isAlreadyInHousehold(receiver.uid)) {
      return false;
    }

    var currentUserUId = _authService.uid;

    var querySnapshots = await Future.wait([
      userCollection
          .doc(receiver.uid)
          .collection('invitations')
          .where('receiverUId', isEqualTo: currentUserUId)
          .get(),
      userCollection
          .doc(receiver.uid)
          .collection('invitations')
          .where('receiverUId', isEqualTo: receiver.uid)
          .get(),
      userCollection
          .doc(currentUserUId)
          .collection('invitations')
          .where('receiverUId', isEqualTo: currentUserUId)
          .get(),
      userCollection
          .doc(currentUserUId)
          .collection('invitations')
          .where('receiverUId', isEqualTo: receiver.uid)
          .get()
    ]);

    if (querySnapshots[0].size != 0 ||
        querySnapshots[1].size != 0 ||
        querySnapshots[2].size != 0 ||
        querySnapshots[3].size != 0) {
      return false;
    }
    return true;
  }

  Future changeFriendRequestStatus(
      String senderUId, InvitationStatus status) async {
    var senderInvitation = await userCollection
        .doc(_authService.uid)
        .collection('invitations')
        .where('senderUId', isEqualTo: senderUId)
        .where('receiverUId', isEqualTo: _authService.uid)
        .get();

    if (senderInvitation.docs.isNotEmpty) {
      var invitation = Invitation.fromMap(senderInvitation.docs[0].data());
      invitation.invitationStatus = status;
      senderInvitation.docs[0].reference.update(invitation.toMap());
    }

    if (status == InvitationStatus.accepted) {
      var receiver = await getByUId(_authService.uid);
      var sender = await getByUId(senderUId);
      await _householdService.isAlreadyInHousehold(senderUId)
          ? await _householdService.addToHousehold(receiver, senderUId)
          : await _householdService
              .createHousehold([sender, receiver], senderUId);
    }
  }
}
