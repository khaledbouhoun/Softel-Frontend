import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Backwidget extends StatelessWidget {
  const Backwidget({super.key});

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();
    if (myServices.sharedPreferences.getString("lang") == "ar") {
      return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: SvgPicture.asset(AppSvg.r, color: AppColor.primaryColor, height: 30, width: 30),
      );
    } else {
      return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: SvgPicture.asset(height: 30, width: 30, AppSvg.l, color: AppColor.primaryColor),
      );
    }
  }
}
