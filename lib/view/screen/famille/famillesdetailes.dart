import 'package:softel/controller/familles/famillesdetailes_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Famillesdetailes extends StatelessWidget {
  const Famillesdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FamillesdetailesController>(
      init: FamillesdetailesController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.background,
          body: SafeArea(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Row(
                    children: [
                      const Backwidget(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(controller.souFamille?.souNom ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
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
                      hintText: 'serch_product'.tr,
                      hintStyle: TextStyle(color: AppColor.grey),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(AppSvg.search, color: AppColor.primaryColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.search!.text = '';
                          controller.update();
                        },
                        icon: Icon(Icons.close, color: AppColor.primaryColor),
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) => controller.searchProducts(value),
                    style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.2),
                  ),
                ),
                const SizedBox(height: 10),
                ProductGrid(
                  physics: const NeverScrollableScrollPhysics(),
                  products: controller.filteredProducts,
                  onTap: (i) async {
                    await controller.goToPageProductDetails(controller.filteredProducts[i]);
                  },
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Visibility(
                      visible: controller.endofproducts.value,
                      child: Center(
                        child: Text(
                          '--- ${controller.message} ---',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
