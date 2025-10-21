import 'package:softel/controller/cart/trakingcartdetaills_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/cart/custom_bottom_navgationbar_cart.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/loadingwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/cart/customitemscartlist.dart';
import 'package:softel/core/constant/imageasset.dart';

class Trakingcartdetaills extends StatelessWidget {
  const Trakingcartdetaills({super.key});

  @override
  Widget build(BuildContext context) {
    // Only initialize ONCE, not both here and in GetBuilder
    // Get.put(CartController()); // <-- Remove this if you use 'init' in GetBuilder

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Text(
          "my_cart".tr,
          style: TextStyle(color: AppColor.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: Backwidget(),
        toolbarHeight: 80,
      ),
      bottomNavigationBar: GetBuilder<TrakingcartdetaillsController>(
        builder: (controller) => BottomNavgationBarCartTraking(totalprice: controller.totalprice()),
      ),
      body: GetBuilder<TrakingcartdetaillsController>(
        init: TrakingcartdetaillsController(),
        builder: (controller) => controller.isloading.value
            ? Center(child: Loadingwidget(width: Get.width / 2))
            : controller.data.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        controller.data.length,
                        (index) => GlassmorphismCartItemTraking(cart: controller.data[index], imagename: ''),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'cart_is_empty'.tr,
                      style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
