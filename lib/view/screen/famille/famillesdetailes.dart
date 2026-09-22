import 'package:softel/controller/familles/famillesdetailes_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Famillesdetailes extends GetView<FamillesdetailesController> {
  const Famillesdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final title = controller.souFamille?.souNom ?? controller.famille?.famNom ?? '';

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: () => controller.fetch(reset: true),
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
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                child: TextField(
                  controller: controller.search,
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
                    hintText: 'serch_product'.tr,
                    hintStyle: TextStyle(color: AppColor.grey),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        AppSvg.search,
                        colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.search.clear();
                        controller.searchProducts('');
                      },
                      icon: Icon(Icons.close, color: AppColor.primaryColor),
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) => controller.searchProducts(value),
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => ProductGrid(
                  isLoadingProducts: controller.isloadingProducts.value,
                  isLoadingMore: controller.isloadingMore.value,
                  hasReachedEnd: controller.endofproducts.value,
                  physics: const NeverScrollableScrollPhysics(),
                  products: controller.filteredProducts.toList(),
                  onTap: (i) async {
                    await controller.goToPageProductDetails(controller.filteredProducts[i]);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
