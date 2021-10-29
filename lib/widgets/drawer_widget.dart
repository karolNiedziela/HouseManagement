import 'package:flutter/material.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/user_service.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool hasFriendRequests = false;
  late int friendRequestsNumber;

  getData() async {
    var invitations = await _userService.getUserFriendRequests();
    if (mounted && invitations.isNotEmpty) {
      setState(() {
        hasFriendRequests = true;
        friendRequestsNumber = invitations.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 60,
                      child: DrawerHeader(
                        decoration: BoxDecoration(color: Colors.indigo),
                        child: Center(
                            child: Text('House  Management',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 1,
                                    color: Colors.white,
                                    fontSize: 18))),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      title: const Text('Household',
                          style: TextStyle(color: Colors.indigo, fontSize: 17)),
                      leading: Icon(Icons.person_sharp, color: Colors.indigo),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/household');
                      },
                    ),
                    ListTile(
                      title: const Text('Shopping list',
                          style: TextStyle(color: Colors.indigo, fontSize: 17)),
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.indigo),
                      onTap: () {
                         Navigator.pop(context);
                        Navigator.pushNamed(context, '/shoppinglist');

                      },
                    ),
                    if (hasFriendRequests)
                      ListTile(
                        title: const Text('Invitations',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 17)),
                        leading: const Icon(Icons.insert_invitation,
                            color: Colors.indigo),
                        trailing: ClipOval(
                          child: Container(
                            color: Colors.indigo[100],
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(friendRequestsNumber.toString(),
                                style: TextStyle(
                                    color: Colors.indigo[900],
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/invitations');
                        },
                      )
                  ],
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          leading:
                              const Icon(Icons.settings, color: Colors.indigo),
                          title: const Text('Settings',
                              style: const TextStyle(
                                  color: Colors.indigo, fontSize: 15)),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.indigo,
                          ),
                          onTap: () async {
                            await _authService.signOut();
                          },
                          title: Text('Sign out',
                              style: TextStyle(
                                  color: Colors.indigo, fontSize: 15)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
