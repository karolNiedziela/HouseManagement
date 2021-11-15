import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/screens/bills/bills_screen.dart';
import 'package:housemanagement/screens/household/base_household_screen.dart';
import 'package:housemanagement/screens/household/invitations/invitation_screen.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_screen.dart';
import 'package:housemanagement/screens/shoppingListDetails/shopping_list_details_screen.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/utils/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return StreamProvider<AppUser?>.value(
        value: AuthService().appUser,
        initialData: null,
        child: MaterialApp(
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
          supportedLocales: const [
            Locale('pl', 'PL'),
          ],
          routes: {
            '/household': (context) => const BaseHouseholdScreen(),
            '/invitations': (context) => const InvitationScreen(),
            '/shoppinglist': (context) => const ShoppingListScreen(),
            '/shoppinglistdetails': (context) =>
                const ShoppingListDetailsScreen(),
            '/bills': (context) => const BillsScreen()
          },
          title: 'House management',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo),
            bottomAppBarTheme:
                const BottomAppBarTheme(shape: CircularNotchedRectangle()),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.indigoAccent,
              unselectedItemColor: Colors.black,
              backgroundColor: Colors.indigo[100],
            ),
          ),
          home: const AuthWrapper(),
        ));
  }
}
