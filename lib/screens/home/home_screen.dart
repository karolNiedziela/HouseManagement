import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';
import 'package:housemanagement/screens/home/shopping_list_screen.dart';
import 'package:housemanagement/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
        ),
        drawer: DrawerWidget(),
        body: ShoppingListScreen());
  }
}
