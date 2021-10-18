import 'package:flutter/material.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/shared/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final AuthService _authService = new AuthService();

  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: authInputDecoration.copyWith(hintText: 'First name', prefixIcon: Icon(Icons.person_sharp)),
    );

    //second name field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: authInputDecoration.copyWith(hintText: 'Second name', prefixIcon: Icon(Icons.person_sharp)),
    );

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
      decoration: authInputDecoration.copyWith(hintText: 'Email', prefixIcon: Icon(Icons.email)),
    );

    // password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        // validator: (value) => null,
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        obscureText: true,
        textInputAction: TextInputAction.next,
        decoration: authInputDecoration.copyWith(hintText: 'Password', prefixIcon: Icon(Icons.lock)));

    // confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        // validator: (value) => null,
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: authInputDecoration.copyWith(hintText: 'Confirm password', prefixIcon: Icon(Icons.lock)));

    final registerButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.indigo,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                loading = true;
              });

            dynamic result = await _authService.createUserWithEmailAndPassword(
              emailEditingController.value.toString(), 
              passwordEditingController.value.toString());
              if (result == null) {
              setState(() {
                loading = false;
                print('Error');
              });
            }
            }


          },
          child: const Text('Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2.0)),
        ));

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.of(context).pop();
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
                      firstNameField,
                      SizedBox(height: 20),
                      secondNameField,
                      SizedBox(height: 20),
                      emailField,
                      SizedBox(height: 20),
                      passwordField,
                      SizedBox(height: 20),
                      confirmPasswordField,
                      SizedBox(height: 30),
                      registerButton,
                      SizedBox(height: 15),
                    ],
                  )),
            ),
          ),
        ));
  }
}
