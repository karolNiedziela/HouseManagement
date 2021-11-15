import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/services/user_service.dart';

class InvitationTile extends StatelessWidget {
  final Invitation invitation;
  final userService = UserService();

  InvitationTile({Key? key, required this.invitation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        invitation.senderFullName,
        style: TextStyle(color: Colors.indigo[900], fontSize: 21.0),
      ),
      tileColor: Colors.indigo[200],
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.accepted);
              },
              icon: Icon(Icons.check, color: Colors.indigo[900], size: 25.0)),
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.rejected);
              },
              icon: Icon(
                Icons.close,
                color: Colors.indigo[900],
                size: 25.0,
              ))
        ],
      ),
    );
  }
}
