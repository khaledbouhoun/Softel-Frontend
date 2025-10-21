import 'package:softel/core/constant/apptheme.dart';
import 'package:softel/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  ThemeData appTheme = themeFrench;

  Future<void> changeLang(String langcode) async {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    appTheme = langcode == "ar" ? themeArabic : themeFrench;
    await myServices.sharedPreferences.setString("lang", langcode);
  
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    // requestPermissionNotification();
    // fcmconfig();
    String? sharedPrefLang = myServices.sharedPreferences.getString("lang");
    if (sharedPrefLang == "fr") {
      language = const Locale("fr");
      appTheme = themeFrench;
      myServices.sharedPreferences.setString("lang", "fr");
    } else if (sharedPrefLang == "ar") {
      language = const Locale("ar");
      appTheme = themeArabic;
      myServices.sharedPreferences.setString("lang", "ar");
    } else if (sharedPrefLang == "en") {
      language = const Locale("en");
      appTheme = themeFrench;
      myServices.sharedPreferences.setString("lang", "en");
    } else {
      language = Locale("fr");
      appTheme = themeFrench;
      // myServices.sharedPreferences.setString("lang", "fr");
    }

    super.onInit();
  }
}
