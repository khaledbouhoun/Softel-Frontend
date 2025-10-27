import 'package:softel/bindings/intialbindings.dart';
import 'package:softel/core/localization/translation.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/changelocal.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      locale: controller.language,
      theme: controller.appTheme,
      initialBinding: InitialBindings(),
      getPages: routes,

      // home: HomeScreen(),
    );
  }
}
