import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/utils/error_snackbar.dart';
import 'package:housemanagement/utils/loading.dart';
import 'package:housemanagement/widgets/textFormFields/email_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/password_text_form_field_widget.dart';
import 'package:housemanagement/widgets/start_title_widget.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;

  const LoginScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  // form_key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var emailField = EmailTextFormFieldWidget(
      controller: emailEditingController,
      textInputAction: TextInputAction.next,
    );

    // password field
    var passwordField = PasswordTextFormFieldWidget(
      controller: passwordEditingController,
      textInputAction: TextInputAction.done,
    );

    final loginButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (mounted) {
            setState(() {
              loading = true;
            });
          }

          dynamic result = await _authService.signIn(
              emailEditingController.text, passwordEditingController.text);
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
      displayButtonText: 'Zaloguj się',
    ));

    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const StartTitleWidget(),
                      emailField,
                      passwordField,
                      const SizedBox(height: 10),
                      loginButton,
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Nie masz konta? ",
                              style: TextStyle(fontSize: 17)),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: const Text("Zarejestruj się",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0,
                                    color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            'Zapomniałeś hasła?',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17.0,
                                color: AppColors.primaryColor),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ));
  }
}
