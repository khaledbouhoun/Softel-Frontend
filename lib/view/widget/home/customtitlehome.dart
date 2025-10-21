import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomTitleHome extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const CustomTitleHome({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(fontSize: 20, color: AppColor.primaryColor, fontWeight: FontWeight.bold),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: onTap,
            child: SvgPicture.asset(AppSvg.r, color: AppColor.primaryColor),
          ),
        ],
      ),
    );
  }
}
