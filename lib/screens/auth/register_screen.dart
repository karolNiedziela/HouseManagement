import 'package:flutter/material.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/utils/error_snackbar.dart';
import 'package:housemanagement/utils/loading.dart';
import 'package:housemanagement/widgets/textFormFields/email_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/name_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/password_text_form_field_widget.dart';
import 'package:housemanagement/widgets/start_title_widget.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;

  const RegisterScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = NameTextFormFieldWidget(
        controller: firstNameEditingController, hintText: 'Imię');

    //second name field
    final secondNameField = NameTextFormFieldWidget(
        controller: secondNameEditingController, hintText: 'Nazwisko');

    // email field
    final emailField =
        EmailTextFormFieldWidget(controller: emailEditingController);

    // password field
    final passwordField =
        PasswordTextFormFieldWidget(controller: passwordEditingController);

    // confirm password field
    final confirmPasswordField = PasswordTextFormFieldWidget(
        controller: confirmPasswordEditingController,
        hintText: 'Powtórz hasło');

    final registerButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (mounted) {
            setState(() {
              loading = true;
            });
          }
          dynamic result = await _authService.registerWithEmailAndPassword(
              emailEditingController.text,
              passwordEditingController.text,
              confirmPasswordEditingController.text,
              firstNameEditingController.text,
              secondNameEditingController.text);
          if (mounted) {
            setState(() {
              loading = false;
            });
          }

          if (result != null) {
            ErrorSnackBar.showError(context, result.toString());
          }
        }
      },
      displayButtonText: 'Zarejestruj się',
    ));

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              toolbarHeight: 30,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.indigo,
                ),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 0, 36, 36),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const StartTitleWidget(),
                          firstNameField,
                          secondNameField,
                          emailField,
                          passwordField,
                          confirmPasswordField,
                          const SizedBox(height: 10),
                          registerButton,
                        ],
                      )),
                ),
              ),
            ));
  }
}
