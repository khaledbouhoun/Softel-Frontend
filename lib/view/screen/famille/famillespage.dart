import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/widget/home/familles_grid.dart';
import 'package:softel/view/widget/home/top_bar.dart';

class FamillesPage extends GetView<FamillesController> {
  const FamillesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: GetBuilder<FamillesController>(
          init: FamillesController(),
          builder: (controller) {
            return ListView(
              children: [
                // ------------------------------------------------------
                // Top bar
                // ------------------------------------------------------
                TopBar(logoUrl: controller.logoUrl, cartCount: 0),

                // ------------------------------------------------------
                // Search
                // ------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: controller.searchController,
                      cursorColor: AppColor.primaryColor,
                      decoration: InputDecoration(
                        fillColor: AppColor.background,
                        filled: true,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),

                        hintText: 'serch_famille'.tr,
                        hintStyle: TextStyle(color: AppColor.grey),

                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(AppSvg.search, colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn)),
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchProducts('');
                          },
                          icon: Icon(Icons.close, color: AppColor.primaryColor),
                        ),
                      ),

                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },

                      onChanged: controller.searchProducts,

                      style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.2),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ------------------------------------------------------
                // Families
                // ------------------------------------------------------
                const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: FamillesGrid()),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
