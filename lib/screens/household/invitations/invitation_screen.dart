import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/models/invitation.dart';
import 'package:housemanagement/screens/household/invitations/invitation_list.dart';
import 'package:housemanagement/services/user_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/validators/email_validator.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';
import 'package:provider/provider.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final TextEditingController emailEditingController = TextEditingController();

  String? _validationMessage;

  @override
  Widget build(BuildContext context) {
    final emailField = BaseTextFormFieldWidget(
      controller: emailEditingController,
      validator: (String? value) {
        var result = EmailValidator.baseEmailValidator(value);
        if (result != null) {
          return result;
        }

        if (_validationMessage != null) {
          return _validationMessage;
        }
        return null;
      },
      prefixIcon: Icons.email,
      hintText: 'Email',
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      errorMaxLines: 3,
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
      context: context,
    ));

    return Column(
      children: [
        Expanded(
          child: StreamProvider<List<Invitation>>.value(
              initialData: const [],
              value: UserService().appUserInvitations,
              child: const InvitationList()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
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
              ),
            ],
          ),
        )
      ],
    );
  }

  Future emailValidator(String receiverEmail) async {
    var message = await _userService.canSendFriendRequest(receiverEmail);
    if (message == null) {
      setState(() {
        _validationMessage = null;
      });
      return;
    }

    setState(() {
      _validationMessage = message;
    });
  }
}
