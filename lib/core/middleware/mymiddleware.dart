import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find<MyServices>();

  @override
  RouteSettings? redirect(String? route) {
    // Don't redirect if already on language selection routes
    if (route == AppRoute.language || route == AppRoute.languagechange) {
      return null;
    }

    String? languageSelected = myServices.sharedPreferences.getString("lang");

    if (languageSelected != null && languageSelected.isNotEmpty) {
      // Language is set → go to company
      return const RouteSettings(name: AppRoute.company);
    } else {
      return const RouteSettings(name: AppRoute.language);
    }
  }
}
