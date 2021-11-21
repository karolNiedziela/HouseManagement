import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:housemanagement/screens/bills/bills_screen.dart';
import 'package:housemanagement/screens/household/base_household_screen.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_screen.dart';
import 'package:housemanagement/screens/shoppingListDetails/shopping_list_details_screen.dart';
import 'package:housemanagement/utils/auth_wrapper.dart';

class AppRoutes {
  static const household = "household";
  static const shoppingList = "shopping_list";
  static const shoppingListDetails = "shopping_list_details";
  static const bills = "bills";
  static const home = "home";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case home:
              return const AuthWrapper();
            case household:
              return const BaseHouseholdScreen();
            case shoppingList:
              return const ShoppingListScreen();
            case shoppingListDetails:
              return const ShoppingListDetailsScreen();
            case bills:
              return const BillsScreen();
            default:
              return const BaseHouseholdScreen();
          }
        });
  }
}
