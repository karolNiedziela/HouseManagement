import 'package:flutter/material.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/screens/household/household_screen.dart';
import 'package:housemanagement/screens/invitations/invitation_screen.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_screen.dart';
import 'package:housemanagement/screens/shoppingListDetails/shopping_list_details_screen.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/utils/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:housemanagement/widgets/main_scaffold.dart';
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
    return StreamProvider<AppUser?>.value(
        value: AuthService().appUser,
        initialData: null,
        child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: [
              const Locale('en', 'EN'),
            ],
            routes: {
              '/household': (context) => const MainScaffoldWidget(
                    body: HouseHouldScreen(),
                    appBarTitle: 'Household',
                  ),
              '/invitations': (context) => const MainScaffoldWidget(
                    body: InvitationScreen(),
                    appBarTitle: 'Invitations',
                  ),
              '/shoppinglist': (context) => const MainScaffoldWidget(
                    body: ShoppingListScreen(),
                    appBarTitle: 'Shopping list',
                  ),
              '/shoppinglistdetails': (context) =>
                  const ShoppingListDetailsScreen()
            },
            title: 'House management',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: const AuthWrapper()));
  }
}
