import 'package:softel/core/constant/routesstr.dart'; // استيراد المسارات
import 'package:softel/core/services/services.dart'; // استيراد الخدمات
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // استيراد GetX
import 'package:lottie/lottie.dart';

class Splachscreen extends GetView<Splachscreencontroller> {
  const Splachscreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is initialized via binding and triggers navigation in onInit()
    controller;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LottieBuilder.asset('assets/lottie/mercerie.json', width: Get.width * 0.9, fit: BoxFit.cover),
      ),
    );
  }
}

class Splachscreencontroller extends GetxController {
  final MyServices myServices = Get.find();
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoute.language);
    });
  }
}
