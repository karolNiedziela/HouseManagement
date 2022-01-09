import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/core/dart_theme_colors.dart';
import 'package:housemanagement/core/font_sizes.dart';
import 'package:housemanagement/core/letter_spacing.dart';
import 'package:housemanagement/core/light_theme_colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemes {
  static final ThemeData defaultTheme = ThemeData(
      primaryColor: AppLightThemeColors.primaryColor,
      primarySwatch: Colors.indigo,
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppLightThemeColors.primaryColor,
          titleTextStyle: TextStyle(
              color: AppBaseColors.whiteColor,
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              letterSpacing: AppLetterSpacing.big),
          iconTheme: IconThemeData(color: AppBaseColors.whiteColor)),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: AppBaseColors.blackColor),
        bodyText2: TextStyle(
            color: AppBaseColors.blackColor, fontSize: AppFontSizes.normal),
        button: TextStyle(
            color: AppBaseColors.whiteColor,
            fontSize: AppFontSizes.large,
            fontWeight: FontWeight.bold,
            letterSpacing: AppLetterSpacing.small),
        subtitle1: TextStyle(
            color: AppBaseColors.blackColor, fontSize: AppFontSizes.big),
        subtitle2: TextStyle(
            color: AppBaseColors.blackColor, fontSize: AppFontSizes.normal),
        headline1: TextStyle(color: AppBaseColors.blackColor),
      ),
      textButtonTheme: TextButtonThemeData(style:
          ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) {
        return const TextStyle(
            color: AppBaseColors.whiteColor,
            letterSpacing: AppLetterSpacing.big,
            fontSize: AppFontSizes.big,
            fontWeight: FontWeight.bold);
      }))),
      cardTheme: const CardTheme(color: AppLightThemeColors.primaryColorLight),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppLightThemeColors.primaryColor),
      iconTheme: const IconThemeData(color: AppBaseColors.blackColor),
      scaffoldBackgroundColor: AppBaseColors.whiteColor,
      bottomAppBarTheme:
          const BottomAppBarTheme(shape: CircularNotchedRectangle()),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppLightThemeColors.selectedItemColor,
        unselectedItemColor: AppLightThemeColors.unselectedItemCOlor,
        backgroundColor: AppLightThemeColors.primaryColorLight,
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: AppLightThemeColors.selectedItemColor,
          unselectedLabelColor: AppLightThemeColors.selectedItemColor),
      indicatorColor: AppLightThemeColors.primaryColor);

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppDarkThemeColors.primaryColor,
    primarySwatch: Colors.green,
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppDarkThemeColors.primaryColor,
        titleTextStyle: TextStyle(
            color: AppBaseColors.whiteColor,
            fontSize: AppFontSizes.large,
            fontWeight: FontWeight.bold,
            letterSpacing: AppLetterSpacing.big),
        iconTheme: IconThemeData(color: AppBaseColors.blackColor)),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: AppBaseColors.whiteColor),
      bodyText2: TextStyle(
          color: AppBaseColors.whiteColor, fontSize: AppFontSizes.normal),
      button: TextStyle(
          color: AppBaseColors.whiteColor,
          fontSize: AppFontSizes.large,
          fontWeight: FontWeight.bold,
          letterSpacing: AppLetterSpacing.small),
      subtitle1: TextStyle(
          color: AppBaseColors.whiteColor, fontSize: AppFontSizes.big),
      subtitle2: TextStyle(
          color: AppBaseColors.blackColor, fontSize: AppFontSizes.normal),
      headline1: TextStyle(color: AppBaseColors.whiteColor),
    ),
    textButtonTheme: TextButtonThemeData(style:
        ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) {
      return const TextStyle(
          color: AppBaseColors.whiteColor,
          letterSpacing: AppLetterSpacing.big,
          fontSize: AppFontSizes.big,
          fontWeight: FontWeight.bold);
    }))),
    scaffoldBackgroundColor: AppDarkThemeColors.backgroundColor,
    cardTheme: const CardTheme(color: AppBaseColors.lightBlackColor),
    iconTheme: const IconThemeData(color: AppBaseColors.whiteColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppDarkThemeColors.primaryColor),
    bottomAppBarTheme:
        const BottomAppBarTheme(shape: CircularNotchedRectangle()),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppBaseColors.blackColor,
      unselectedItemColor: AppBaseColors.greyColor,
      backgroundColor: AppDarkThemeColors.primaryColorLight,
    ),
    indicatorColor: AppDarkThemeColors.primaryColor,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
  );
}
