import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/screens/invitations/invitation_tile.dart';
import 'package:provider/provider.dart';

class InvitationList extends StatefulWidget {
  const InvitationList({Key? key}) : super(key: key);

  @override
  _InvitationListState createState() => _InvitationListState();
}

class _InvitationListState extends State<InvitationList> {
  @override
  Widget build(BuildContext context) {
    final appUserInvitations = Provider.of<List<Invitation>>(context);

    return ListView.builder(
      itemCount: appUserInvitations.length,
      itemBuilder: ((context, index) {
        return InvitationTile(invitation: appUserInvitations[index]);
      }),
    );
  }
}
