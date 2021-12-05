import 'package:flutter/material.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/models/drawer_navigation_tile.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/core/routes.dart';
import 'package:housemanagement/utils/auth_wrapper.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthService _authService = AuthService();

  final List<DrawerNavigationTile> _topNavigationTiles = <DrawerNavigationTile>[
    DrawerNavigationTile(
        text: "Grupa domowa",
        iconData: Icons.person_sharp,
        route: AppRoutes.household),
    DrawerNavigationTile(
        text: "Listy zakupów",
        iconData: Icons.shopping_cart,
        route: AppRoutes.shoppingList),
    DrawerNavigationTile(
        text: "Rachunki", iconData: Icons.payments, route: AppRoutes.bills)
  ];

  final List<DrawerNavigationTile> _bottomNavigationTiles =
      <DrawerNavigationTile>[
    DrawerNavigationTile(
        text: "Ustawienia",
        iconData: Icons.settings,
        route: AppRoutes.userSettings)
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 60,
                    child: DrawerHeader(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: const Center(
                          child: Text('House  Management',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  letterSpacing: 1,
                                  color: AppBaseColors.whiteColor,
                                  fontSize: 18))),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ..._buildTopNavigationTiles()
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  ..._buildBottomNavigationTiles(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () async {
                      await _authService.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthWrapper()));
                    },
                    title: Text('Wyloguj się',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 15)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopNavigationTiles() {
    var navigationTiles = <Widget>[];

    for (var i = 0; i < _topNavigationTiles.length; i++) {
      navigationTiles.add(ListTile(
        title: Text(_topNavigationTiles[i].text,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontSize: 17)),
        leading: Icon(_topNavigationTiles[i].iconData,
            color: Theme.of(context).primaryColor),
        onTap: () {
          Navigator.pushReplacementNamed(context, _topNavigationTiles[i].route);
        },
      ));
    }

    return navigationTiles;
  }

  List<Widget> _buildBottomNavigationTiles() {
    var navigationTiles = <Widget>[];

    for (var i = 0; i < _bottomNavigationTiles.length; i++) {
      navigationTiles.add(ListTile(
        title: Text(_bottomNavigationTiles[i].text,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontSize: 17)),
        leading: Icon(_bottomNavigationTiles[i].iconData,
            color: Theme.of(context).primaryColor),
        onTap: () {
          Navigator.pushReplacementNamed(
              context, _bottomNavigationTiles[i].route);
        },
      ));
    }

    return navigationTiles;
  }
}
