import 'package:flutter_svg/flutter_svg.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/localization/changelocal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Language extends GetView<LocaleController> {
  Language({super.key});

  final Crud crud = Crud();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Text(
                  "language".tr,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                customButtonLang(
                  flag: 'fr',
                  textbutton: "French",
                  onPressed: () async {
                    await controller.changeLang("fr");
                    await Get.offNamed(AppRoute.company);
                  },
                ),
                customButtonLang(
                  flag: 'en',
                  textbutton: "English",
                  onPressed: () async {
                    await controller.changeLang("en");
                    await Get.offNamed(AppRoute.company);
                    Get.back();
                  },
                ),
                customButtonLang(
                  flag: 'dz',
                  textbutton: "العربية",
                  onPressed: () async {
                    await controller.changeLang("ar");
                    await Get.offNamed(AppRoute.company);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Languagechange extends GetView<LocaleController> {
  const Languagechange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "language".tr,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                customButtonLang(
                  flag: 'fr',
                  textbutton: "French",
                  onPressed: () async {
                    await controller.changeLang("fr");
                    Get.back();
                  },
                ),
                customButtonLang(
                  flag: 'en',
                  textbutton: "English",
                  onPressed: () async {
                    await controller.changeLang("en");
                    Get.back();
                  },
                ),
                customButtonLang(
                  flag: 'dz',
                  textbutton: "العربية",
                  onPressed: () async {
                    await controller.changeLang("ar");
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customButtonLang({required String flag, required String textbutton, required void Function()? onPressed}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColor.primaryColor, width: 1),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            textbutton,
            style: TextStyle(color: AppColor.primaryColor, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 14),
          SvgPicture.asset('assets/svg/$flag.svg', height: 28, width: 28),
        ],
      ),
    ),
  );
}
