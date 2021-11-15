import 'package:flutter/material.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/utils/auth_wrapper.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
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
                    const SizedBox(height: 15),
                    ListTile(
                      title: const Text('Grupa domowa',
                          style: TextStyle(color: Colors.indigo, fontSize: 17)),
                      leading:
                          const Icon(Icons.person_sharp, color: Colors.indigo),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/household');
                      },
                    ),
                    ListTile(
                      title: const Text('Listy zakupów',
                          style: TextStyle(color: Colors.indigo, fontSize: 17)),
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.indigo),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/shoppinglist');
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Rachunki',
                        style: TextStyle(color: Colors.indigo, fontSize: 17),
                      ),
                      leading: const Icon(Icons.payments, color: Colors.indigo),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/bills');
                      },
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.settings, color: Colors.indigo),
                      title: Text('Ustawienia',
                          style: TextStyle(color: Colors.indigo, fontSize: 15)),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.indigo,
                      ),
                      onTap: () async {
                        await _authService.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthWrapper()));
                      },
                      title: const Text('Wyloguj się',
                          style: TextStyle(color: Colors.indigo, fontSize: 15)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
  }
}
