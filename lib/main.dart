import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/core/themes.dart';
import 'package:housemanagement/models/app_user.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/core/routes.dart';
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
          onGenerateRoute: AppRoutes.onGenerateRoute,
          title: 'House management',
          theme: AppThemes.defaultTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.dark, 
          home: const AuthWrapper(),
        ));
  }
}
