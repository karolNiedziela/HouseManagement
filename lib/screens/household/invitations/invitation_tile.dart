import 'package:flutter/material.dart';
import 'package:housemanagement/core/font_sizes.dart';
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
        style: const TextStyle(fontSize: AppFontSizes.large),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.accepted);
              },
              icon: Icon(Icons.check,
                  color: Theme.of(context).primaryColor, size: 25.0)),
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.rejected);
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
                size: 25.0,
              ))
        ],
      ),
    );
  }
}
