import 'package:flutter/material.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/screens/auth/authenticate_screen.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    if (appUser == null) {
      return const AuthenticateScreen();
    }

    return const ShoppingListScreen();
  }
}
