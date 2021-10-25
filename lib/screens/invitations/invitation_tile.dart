import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';

class InvitationTile extends StatelessWidget {
  final Invitation invitation;

  const InvitationTile({Key? key, required this.invitation}) : super(key: key);

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
              onPressed: () {},
              icon: Icon(Icons.check, color: Colors.indigo[900], size: 25.0)),
          IconButton(
              onPressed: () {},
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
