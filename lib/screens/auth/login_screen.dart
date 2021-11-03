import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';
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
    final emailField =
        EmailTextFormFieldWidget(controller: emailEditingController);

    // password field
    var passwordField =
        PasswordTextFormFieldWidget(controller: passwordEditingController);

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
      displayButtonText: 'Login',
    ));

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
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
                              const Text("Don't have an account? ",
                                  style: TextStyle(fontSize: 17)),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: const Text("Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.0,
                                        color: Colors.indigo)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Forgot password?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0,
                                    color: Colors.indigo),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ));
  }
}
