import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/bindings/initial_bindings.dart';
import 'package:softel/core/localization/changelocal.dart';
import 'package:softel/core/localization/translation.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/routes.dart';

void main() async {
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      locale: Get.find<LocaleController>().language,
      fallbackLocale: const Locale('en', 'US'),
      theme: Get.find<LocaleController>().appTheme,
      initialBinding: InitialBindings(),
      getPages: routes,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
