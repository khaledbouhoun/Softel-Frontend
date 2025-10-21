import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/controller/home/homescreen_controller.dart';
import 'package:softel/controller/traking/traking_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    return GetBuilder<HomeScreenController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: controller.listPage.elementAt(controller.initialTab)),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
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
                  GButton(
                    icon: Icons.home, // This is still required, but will be hidden by the custom leading
                    text: 'home'.tr,
                    textColor: AppColor.primaryColor,
                    textSize: 15,
                    activeBorder: Border.all(color: AppColor.primaryColor),
                    leading: SvgPicture.asset(
                      controller.initialTab == 0 ? AppSvg.home2 : AppSvg.homee, // Update this path to your SVG asset
                      color: AppColor.primaryColor, // Optional: set color if your SVG is single-color
                    ),
                  ),
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
                  ), // Example: Updated icon/text
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
                  ), // Example: Updated icon/text
                  GButton(
                    icon: Icons.person,
                    text: 'setting'.tr,
                    textColor: AppColor.primaryColor,
                    textSize: 15,
                    activeBorder: Border.all(color: AppColor.primaryColor),
                    leading: SvgPicture.asset(controller.initialTab == 3 ? AppSvg.user2 : AppSvg.user, color: AppColor.primaryColor),
                  ), // Example: Updated icon/text
                ],
                selectedIndex: controller.initialTab,
                onTabChange: (index) {
                  // --- Logic to re-run controller methods ---
                  switch (index) {
                    case 0: // Index of the famille page in _widgetOptions
                      if (Get.isRegistered<HomeController>()) {
                        print("Tab 0 selected: Refreshing familles...");
                        Get.find<HomeController>().fetchAll();
                      }
                      break;
                    case 1:
                      if (Get.isRegistered<FamillesController>()) {
                        print("Tab 1 selected: Refreshing familles...");
                        Get.find<FamillesController>().fetch();
                      }
                      break;
                    case 2:
                      if (Get.isRegistered<TrakingControllerDetails>()) {
                        print("Tab 2 selected: Refreshing Tracking...");
                        Get.find<TrakingController>().fetch();
                      }
                      break;
                    case 3:
                    // Add cases for other tabs if needed
                  }
                  // --- End of added logic ---

                  controller.initialTab = index;
                  controller.update();
                },
              ),
            ),
          ),
        ),
      ),
      // Scaffold(
      //       // body: controller.listPage.elementAt(controller.currentpage),
      //       body: PageView(
      //         controller: controller.pageController,
      //         physics: const NeverScrollableScrollPhysics(),
      //         children: List.generate(controller.listPage.length, (index) => controller.listPage[index] ?? CircularProgressIndicator()),
      //       ),
      //       extendBody: true,
      //       bottomNavigationBar: CustomBottomAppBarHome(),
      //     )
    );
  }
}
