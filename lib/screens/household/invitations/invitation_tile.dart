import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
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
        style: const TextStyle(color: AppColors.primaryColor, fontSize: 21.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.accepted);
              },
              icon: const Icon(Icons.check,
                  color: AppColors.primaryColor, size: 25.0)),
          IconButton(
              onPressed: () {
                userService.changeFriendRequestStatus(
                    invitation.senderUId, InvitationStatus.rejected);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.primaryColor,
                size: 25.0,
              ))
        ],
      ),
    );
  }
}
