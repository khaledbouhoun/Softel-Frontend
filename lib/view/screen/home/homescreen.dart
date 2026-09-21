import 'package:softel/controller/home/homescreen_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: GetBuilder<HomeScreenController>(builder: (controller) => controller.listPage.elementAt(controller.initialTab)),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: .1))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                // Home Tab
                GButton(
                  icon: Icons.home,
                  text: 'home'.tr,
                  textColor: AppColor.primaryColor,
                  textSize: 15,
                  activeBorder: Border.all(color: AppColor.primaryColor),
                  leading: SvgPicture.asset(controller.initialTab == 0 ? AppSvg.home2 : AppSvg.homee, color: AppColor.primaryColor),
                ),

                // Families Tab
                GButton(
                  icon: Icons.category,
                  text: 'familles'.tr,
                  textColor: AppColor.primaryColor,
                  textSize: 15,
                  activeBorder: Border.all(color: AppColor.primaryColor),
                  leading: SvgPicture.asset(
                    controller.initialTab == 1 ? AppSvg.widget2 : AppSvg.widget2Filled,
                    color: AppColor.primaryColor,
                  ),
                ),

                // Orders Tab
                GButton(
                  icon: Icons.spatial_tracking,
                  text: 'orders'.tr,
                  textColor: AppColor.primaryColor,
                  textSize: 15,
                  activeBorder: Border.all(color: AppColor.primaryColor),
                  leading: SvgPicture.asset(
                    controller.initialTab == 2 ? AppSvg.documentfilled : AppSvg.document,
                    color: AppColor.primaryColor,
                  ),
                ),

                // Settings Tab
                GButton(
                  icon: Icons.person,
                  text: 'setting'.tr,
                  textColor: AppColor.primaryColor,
                  textSize: 15,
                  activeBorder: Border.all(color: AppColor.primaryColor),
                  leading: SvgPicture.asset(controller.initialTab == 3 ? AppSvg.user2 : AppSvg.user, color: AppColor.primaryColor),
                ),
              ],
              selectedIndex: controller.initialTab,
              onTabChange: (index) {
                controller.changeTab(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
