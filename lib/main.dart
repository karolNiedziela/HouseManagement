import 'package:flutter/material.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/screens/household/household_screen.dart';
import 'package:housemanagement/screens/invitations/invitation_screen.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/shared/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
        value: AuthService().appUser,
        initialData: null,
        child: MaterialApp(
            routes: {
              '/household': (context) => HouseHouldScreen(),
              '/invitations': (context) => InvitationScreen()
            },
            title: 'House management',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: AuthWrapper()));
  }
}
