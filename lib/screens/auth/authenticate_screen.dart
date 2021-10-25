import 'package:flutter/material.dart';
import 'package:housemanagement/screens/auth/login_screen.dart';
import 'package:housemanagement/screens/auth/register_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toggleView: toggleView);
    }

    return RegisterScreen(toggleView: toggleView);
  }
}
