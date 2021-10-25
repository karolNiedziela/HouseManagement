import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  String receiverUId;
  String senderUId;
  String senderFullName;
  InvitationStatus invitationStatus; // 0 - rejected, 1 - accepted

  Invitation({
    required this.receiverUId,
    required this.senderUId,
    required this.senderFullName,
    this.invitationStatus = InvitationStatus.none,
  });

  factory Invitation.fromMap(Map<String, dynamic> map) {
    int value = map['invitationStatus'];
    return Invitation(
        receiverUId: map["receiverUId"],
        senderUId: map["senderUId"],
        senderFullName: map['senderFullName'],
        invitationStatus: InvitationStatus.values[value]);
  }

  Map<String, dynamic> toMap() {
    return {
      'receiverUId': receiverUId,
      'senderUId': senderUId,
      'senderFullName': senderFullName,
      'invitationStatus': invitationStatus.index
    };
  }
}

enum InvitationStatus {
  none,
  accepted,
  rejected,
}
