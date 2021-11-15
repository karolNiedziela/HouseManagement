import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/screens/household/invitations/invitation_list.dart';
import 'package:housemanagement/services/user_service.dart';
import 'package:provider/provider.dart';

class InvitationTab extends StatelessWidget {
  const InvitationTab({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider<List<Invitation>>.value(
            initialData: const [],
            value: UserService().appUserInvitations,
            child: const InvitationList()),
    );
  }
}