import 'package:softel/controller/cart/cart_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/cart/custom_bottom_navgationbar_cart.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/cart/customitemscartlist.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

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
      bottomNavigationBar: GetBuilder<CartController>(builder: (controller) => BottomNavgationBarCart(totalprice: controller.totalprice())),
      body: GetBuilder<CartController>(
        init: CartController(),
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
                        (index) => GlassmorphismCartItem(
                          cart: controller.data[index],
                          imagename: '',
                          onRemove: () async {
                            await controller.delete(context, controller.data[index]);
                          },
                          onPressed: () async {
                            await controller.edit(controller.data[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Text("cart_empty".tr, style: TextStyle(fontSize: 18, color: Colors.grey)),
              ),
      ),
    );
  }
}
