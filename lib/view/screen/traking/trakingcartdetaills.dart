import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/controller/cart/trakingcartdetaills_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/cart/custom_bottom_navgationbar_cart.dart';
import 'package:softel/view/widget/cart/customitemscartlist.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class Trakingcartdetaills extends GetView<TrakingcartdetaillsController> {
  const Trakingcartdetaills({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
          leading: const Backwidget(),
          toolbarHeight: 80,
        ),
        bottomNavigationBar: Obx(
          () => BottomNavgationBarCartTraking(totalprice: controller.totalprice()),
        ),
        body: RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: controller.view,
          child: Obx(
            () {
              if (controller.isloading.value && controller.data.isEmpty) {
                return Center(child: Loadingwidget(width: Get.width / 2));
              }
              if (controller.data.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: Get.height * 0.3),
                    Center(
                      child: Text(
                        'cart_is_empty'.tr,
                        style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  return GlassmorphismCartItemTraking(
                    cart: controller.data[index],
                    imagename: '',
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
