import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';

class AppThemes {
  static final ThemeData defaultTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      primarySwatch: Colors.indigo,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor),
      iconTheme: const IconThemeData(color: AppColors.lightBlackColor),
      bottomAppBarTheme:
          const BottomAppBarTheme(shape: CircularNotchedRectangle()),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.selectedItemColor,
        unselectedItemColor: AppColors.unselectedItemCOlor,
        backgroundColor: AppColors.primaryColorLight,
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: AppColors.selectedItemColor,
          unselectedLabelColor: AppColors.selectedItemColor),
      indicatorColor: AppColors.primaryColor);



    static final ThemeData darkTheme = ThemeData(
      primaryColor: Colors.green,
      primarySwatch: Colors.green,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.green, 
      titleTextStyle: TextStyle(color: AppColors.whiteColor, fontSize: 20)),
      textTheme: const TextTheme(
              bodyText1: TextStyle(color: AppColors.whiteColor),
              subtitle1: TextStyle(color: AppColors.whiteColor),
              headline1: TextStyle(color: AppColors.whiteColor),
                ),
      scaffoldBackgroundColor: Colors.grey[800],          
      cardTheme: const CardTheme(color: Colors.white30),
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor),
      bottomAppBarTheme:
          const BottomAppBarTheme(shape: CircularNotchedRectangle()),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.selectedItemColor,
        unselectedItemColor: AppColors.unselectedItemCOlor,
        backgroundColor: AppColors.primaryColorLight,
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: AppColors.selectedItemColor,
          unselectedLabelColor: AppColors.selectedItemColor),
      indicatorColor: AppColors.primaryColor,
      popupMenuTheme: const PopupMenuThemeData(color: Colors.black),);
}
