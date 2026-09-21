import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mymiddlewareproduct extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final myServices = Get.find<MyServices>();

    String? googleId = myServices.sharedPreferences.getString("google_id");

    if (googleId == null || googleId.isEmpty) {
      return const RouteSettings(name: AppRoute.login);
    }

    return null;
  }
}
