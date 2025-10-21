import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColor extends GetxController {
  // static const Color primaryColor = ;
  // static const Color primaryColor = Color.fromARGB(255, 139, 9, 129);
  // static const Color primaryColor = Color.fromARGB(255, 197, 0, 0);
  static Color primaryColor = Color(0xFF069ce4);
  static Color companySecendColor = Colors.black;
  static Color secondaryColor = Colors.black;
  static const Color prixColor = Color.fromARGB(255, 255, 72, 16);
  static const Color thirdColor = Color(0xffc0a150);
  static const Color background = Colors.white;
  static const Color warning = Color(0xffFF0000);
  static const Color success = Color.fromARGB(255, 1, 99, 4);
  static const Color grey = Color.fromARGB(255, 133, 132, 132);
  static const Color yallidineColor = Color(0xffd8181c);
  static const Color cash = Color.fromARGB(255, 11, 151, 22);
  // traking colors
  static const Color trakingColor1 = Colors.blue;
  static const Color trakingColor2 = Colors.orange;
  static const Color trakingColor3 = Colors.red;
  static const Color trakingColor4 = Colors.green;

  void updateTheme(Color primary, {Color? secondary}) {
    primaryColor = primary;
    if (secondary != null) {
      companySecendColor = secondary;
    }
    update();
  }

  // ThemeData get themeData => ThemeData(
  //   primaryColor: primaryColor.value,
  //   colorScheme: ColorScheme.fromSeed(seedColor: primaryColor.value),
  //   appBarTheme: AppBarTheme(backgroundColor: primaryColor.value, foregroundColor: Colors.white),
  // );
}

// class ThemeController extends GetxController {
//   Color primaryColor = AppColor.primaryColor.obs;
//   Color secondaryColor = AppColor.secondaryColor.obs;

// }
