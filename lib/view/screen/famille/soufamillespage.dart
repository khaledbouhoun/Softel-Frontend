import 'package:softel/controller/familles/soufamillescontroller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/home/soufamilles_grid.dart';

class Soufamillespage extends StatelessWidget {
  const Soufamillespage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Soufamillescontroller());
    return GetBuilder<Soufamillescontroller>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            backgroundColor: AppColor.background,
            elevation: 0,
            title: Text(
              controller.selectedfamille.famNom!,
              style: TextStyle(color: AppColor.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: Backwidget(),
            toolbarHeight: 100,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  child: TextField(
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColor.primaryColor),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColor.primaryColor),
                      ),
                      hintText: 'serch_sous_famille'.tr,
                      hintStyle: TextStyle(color: AppColor.grey),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(AppSvg.search, color: AppColor.primaryColor),
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.searchController.clear();
                          controller.searchProducts("");
                        },
                        icon: Icon(Icons.close, color: AppColor.primaryColor),
                      ),
                    ),
                    controller: controller.searchController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      controller.searchProducts(value);
                    },
                    style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.2),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SoufamillesGrid()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
