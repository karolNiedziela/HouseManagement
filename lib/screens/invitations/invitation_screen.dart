import 'package:flutter/material.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/screens/invitations/invitation_list.dart';
import 'package:housemanagement/services/user_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:provider/provider.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final TextEditingController emailEditingController = TextEditingController();

  dynamic _validationMessage;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => _validationMessage,
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          hintText: 'Email',
          errorMaxLines: 3,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final addButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        await emailValidator(emailEditingController.text);

        if (_formKey.currentState!.validate()) {
          await _userService.sendFriendRequest(emailEditingController.text);
          Navigator.pop(context);
        }
      },
      displayButtonText: 'Wyślij zaproszenie',
    ));

    return StreamProvider<List<Invitation>>.value(
        initialData: const [],
        value: UserService().appUserInvitations,
        child: Scaffold(
            body: const InvitationList(),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  FormDialog.showFormDialog(
                      context: context,
                      formContent: [
                        emailField,
                        const SizedBox(height: 10),
                        addButton
                      ],
                      key: _formKey,
                      dialogHeader: "Zaproszenie");
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.blueAccent[200])));
  }

  Future emailValidator(String receiverEmail) async {
    _validationMessage = null;
    setState(() {});

    if (receiverEmail.isEmpty) {
      _validationMessage = 'Podaj adres email.';
      setState(() {});
      return;
    }

    // reg expression for email
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(receiverEmail)) {
      _validationMessage = "Podaj prawidłowy adres email.";
      setState(() {});
      return;
    }

    bool isValid = await _userService.canSendFriendRequest(receiverEmail);

    if (!isValid) {
      _validationMessage = "Już wysłałeś zaproszenie do tej osoby.";
      setState(() {});
    }
  }
}
