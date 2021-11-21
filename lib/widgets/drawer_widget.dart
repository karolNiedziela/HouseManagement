import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
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
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                    child: Center(
                        child: Text('House  Management',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                letterSpacing: 1,
                                color: AppColors.whiteColor,
                                fontSize: 18))),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  title: const Text('Grupa domowa',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 17)),
                  leading: const Icon(Icons.person_sharp,
                      color: AppColors.primaryColor),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.household);
                  },
                ),
                ListTile(
                  title: const Text('Listy zakupów',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 17)),
                  leading: const Icon(Icons.shopping_cart,
                      color: AppColors.primaryColor),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.shoppingList);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Rachunki',
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 17),
                  ),
                  leading:
                      const Icon(Icons.payments, color: AppColors.primaryColor),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.bills);
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
                  leading: Icon(Icons.settings, color: AppColors.primaryColor),
                  title: Text('Ustawienia',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 15)),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () async {
                    await _authService.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthWrapper()));
                  },
                  title: const Text('Wyloguj się',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 15)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
