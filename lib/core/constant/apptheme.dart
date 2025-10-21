import 'package:softel/core/constant/color.dart';
import 'package:flutter/material.dart';

ThemeData themeFrench = ThemeData(
  fontFamily: "Cairo",
  floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColor.primaryColor),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColor.primaryColor),
    titleTextStyle: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold, fontFamily: "PlayfairDisplay", fontSize: 25),
    backgroundColor: Colors.grey[50],
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
    bodyLarge: TextStyle(height: 2, color: AppColor.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
    bodyMedium: TextStyle(height: 2, color: AppColor.secondaryColor, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);

ThemeData themeArabic = ThemeData(
  fontFamily: "Cairo",
  textTheme: TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
    bodyLarge: TextStyle(height: 2, color: AppColor.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
    bodyMedium: TextStyle(height: 2, color: AppColor.secondaryColor, fontSize: 14),
  ),
  primarySwatch: Colors.blue,
);
