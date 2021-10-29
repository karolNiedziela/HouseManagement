import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/screens/invitations/invitation_list.dart';
import 'package:housemanagement/services/user_service.dart';
import 'package:provider/provider.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Invitation>>.value(
        initialData: [],
        value: UserService().appUserInvitations,
        child: Container(
            child: InvitationList()));
  }
}
