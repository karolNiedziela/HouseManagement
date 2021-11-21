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
}
