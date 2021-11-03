import 'package:flutter/material.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/services/user_service.dart';

class HouseHouldScreen extends StatefulWidget {
  const HouseHouldScreen({Key? key}) : super(key: key);

  @override
  _HouseHouldScreenState createState() => _HouseHouldScreenState();
}

class _HouseHouldScreenState extends State<HouseHouldScreen> {
  final UserService _userService = UserService();
  final HouseholdService _householdService = HouseholdService();
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final TextEditingController emailEditingController = TextEditingController();

  dynamic _validationMessage;
  String fullName = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _householdService.household,
        builder: (context, AsyncSnapshot<Household> snapshot) {
          switch (snapshot.connectionState) {
            default:
              return Scaffold(
                  body: ListView.builder(
                      itemCount:
                          snapshot.hasData ? snapshot.data!.users.length : 0,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              leading: CircleAvatar(
                                child: Text(_getFirstLettersFromFullName(
                                    snapshot.data!.users[index].fullName)),
                              ),
                              title: snapshot.data!.users[index].isOwner
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(snapshot
                                            .data!.users[index].fullName),
                                        const Icon(Icons.star_border)
                                      ],
                                    )
                                  : Text(snapshot.data!.users[index].fullName)),
                        );
                      }),
                  floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        // FormDialog.showFormDialog(context, formContent: [])

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
                                            Focus(
                                              child: TextFormField(
                                                autofocus: false,
                                                controller:
                                                    emailEditingController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) =>
                                                    _validationMessage,
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
                                                    errorMaxLines: 3,
                                                    contentPadding:
                                                        const EdgeInsets.fromLTRB(
                                                            20, 15, 20, 15),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .indigo,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15))),
                                              ),
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
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  onPressed: () async {
                                                    await emailValidator(
                                                        emailEditingController
                                                            .text);

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
                                                      textAlign:
                                                          TextAlign.center,
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
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.blueAccent[200]));
          }
        });
  }

  _getFirstLettersFromFullName(String fullName) {
    return fullName.trim().split(' ').map((word) => word[0]).join();
  }

  Future emailValidator(String receiverEmail) async {
    _validationMessage = null;
    setState(() {});

    if (receiverEmail.isEmpty) {
      _validationMessage = 'Please enter email';
      setState(() {});
      return;
    }

    // reg expression for email
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(receiverEmail)) {
      _validationMessage = "Please enter a valid email";
      setState(() {});
      return;
    }

    bool isValid = await _userService.canSendFriendRequest(receiverEmail);

    if (!isValid) {
      _validationMessage =
          "You already sent friend request or user is already in household.";
      setState(() {});
    }
  }
}
