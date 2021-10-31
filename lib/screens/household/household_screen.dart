import 'package:flutter/material.dart';
import 'package:housemanagement/services/user_service.dart';
import 'package:housemanagement/utils/loading.dart';

class HouseHouldScreen extends StatefulWidget {
  const HouseHouldScreen({Key? key}) : super(key: key);

  @override
  _HouseHouldScreenState createState() => _HouseHouldScreenState();
}

class _HouseHouldScreenState extends State<HouseHouldScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final TextEditingController emailEditingController = TextEditingController();

  Future<void> getAppUser() async {
    await _userService
        .getByUId(null)
        .then((value) => fullName = "${value.firstName} ${value.secondName}");
  }

  String fullName = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAppUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Loading();
          } else {
            return Scaffold(
                body: ListView(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Text(''),
                        ),
                        title: Text(fullName),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              backgroundColor: Colors.indigo[100],
                              child: SizedBox(
                                height: 300,
                                child: Center(
                                  child: Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                            'Enter the email of the user to whom you want to send the invitation',
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            autofocus: false,
                                            controller: emailEditingController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return ('Please enter email');
                                              }

                                              // reg expression for email
                                              if (!RegExp(
                                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                  .hasMatch(value)) {
                                                return ("Please enter a valid email");
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              emailEditingController.text =
                                                  value!;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    const Icon(Icons.email),
                                                hintText: 'Email',
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 15, 20, 15),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.indigo,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.indigo,
                                              child: MaterialButton(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 15, 20, 15),
                                                minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await _userService
                                                        .sendFriendRequest(
                                                            emailEditingController
                                                                .text);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text(
                                                    'Send invitation',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        letterSpacing: 2.0)),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                      // await _userService.sendFriendRequest("test@email.com");
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.blueAccent[200]));
          }
        });
  }
}
