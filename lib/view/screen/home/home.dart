import 'package:flutter_svg/flutter_svg.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/screen/product/search_page.dart';
import 'package:softel/view/widget/home/category_selector.dart';
import 'package:softel/view/widget/home/customcardhome.dart';
import 'package:softel/view/widget/home/top_bar.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.background,
          strokeWidth: 2,
          backgroundColor: AppColor.primaryColor,
          onRefresh: () async {
            await Get.find<HomeController>().fetchAll();
          },
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              return ListView(
                controller: controller.scrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  TopBar(logoUrl: controller.logoUrl),
                  CustomCardHome(images: controller.bannerImage),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      controller.productssearch = controller.products;
                      Get.to(() => const SearchPage());
                    },
                    child: AbsorbPointer(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColor.primaryColor),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            SvgPicture.asset(AppSvg.search, color: AppColor.primaryColor, width: 24, height: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'serch_product'.tr,
                                style: TextStyle(color: AppColor.grey, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.2),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(AppSvg.search, color: AppColor.primaryColor, width: 16, height: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'quick_search'.tr,
                                    style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w500, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('familles'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  FamilleSelector(
                    familles: controller.familleproducts,
                    selectedIndex: controller.selectedfamille,
                    onfamilleSelected: (i) {
                      controller.selectedfamille = i;
                      controller.products.clear();
                      controller.filteredproductsbyfamille.clear();
                      controller.fetch();
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('products'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  SizedBox(height: 10),
                  controller.isloadingProducts.value
                      ? Center(child: Column(children: [const SizedBox(height: 80), Loadingwidget(width: 100)]))
                      : ProductGrid(
                          products: controller.filteredproductsbyfamille,
                          onTap: (i) {
                            controller.goToPageProductDetails(controller.products[i]);
                          },
                        ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Visibility(
                        visible: controller.endofproducts.value,
                        child: Center(
                          child: Text(
                            'no_more_products'.tr,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
