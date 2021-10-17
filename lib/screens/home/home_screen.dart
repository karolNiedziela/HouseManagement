import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
        ),
        drawer: Drawer(
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
                          style: TextStyle(color: Colors.indigo, fontSize: 15)),
                      leading: Icon(Icons.person_sharp, color: Colors.indigo),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Shopping list',
                          style: TextStyle(color: Colors.indigo, fontSize: 15)),
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.indigo),
                      onTap: () {},
                    ),
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
                        const ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.indigo,
                          ),
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
        ),
        body: Text('hello'));
  }
}
