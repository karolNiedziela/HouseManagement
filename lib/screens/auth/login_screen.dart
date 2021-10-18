import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/screens/auth/register_screen.dart';
import 'package:housemanagement/shared/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form_key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailEditingController =
      new TextEditingController();
  final TextEditingController passwordEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      // validator: (value) => null,
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: authInputDecoration.copyWith(hintText: 
      'Email', prefixIcon: Icon(Icons.email),
      )
    );

    // password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        keyboardType: TextInputType.visiblePassword,
        // validator: (value) => null,
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: authInputDecoration.copyWith(hintText: 'Password', prefixIcon: Icon(Icons.lock)));

    final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigo,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {},
          child: const Text('Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2.0)),
        ));

    return Scaffold(
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
                      SizedBox(
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                size: 100.0,
                                color: Colors.indigo,
                              ),
                              Text('House',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      letterSpacing: 2)),
                              const Text('Management',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 40,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2)),
                            ],
                          )),
                      SizedBox(height: 5),
                      emailField,
                      SizedBox(height: 20),
                      passwordField,
                      SizedBox(height: 30),
                      loginButton,
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? ",
                              style: TextStyle(fontSize: 17)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: Text("Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0,
                                    color: Colors.indigo)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
