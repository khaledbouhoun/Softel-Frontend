// ignore_for_file: prefer_const_constructors

import 'package:softel/controller/cart/cart_controller.dart';
import 'package:softel/controller/cart/trakingcartdetaills_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavgationBarCart extends GetView<CartController> {
  final String totalprice;

  const BottomNavgationBarCart({super.key, required this.totalprice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => controller.confirmcommande(context),
                    child: Obx(
                      () => Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryColor.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: controller.isloadingConfirmButton.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "confirm".tr,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'arial'),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${"total".tr} :",
                          // "$totalprice  ${'da'.tr}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontFamily: 'arial'),
                        ),
                        Text(
                          "$totalprice  ${'da'.tr}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontFamily: 'arial'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // CustomButtonCart(
          //   textbutton: "checkout".tr,
          //   onPressed: () {
          //     controller.goToPageCheckout();
          //   },
          // ),
        ],
      ),
    );
  }
}

class BottomNavgationBarCartTraking extends GetView<TrakingcartdetaillsController> {
  final String totalprice;

  const BottomNavgationBarCartTraking({super.key, required this.totalprice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${"total".tr} :",
                    // "$totalprice  ${'da'.tr}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontFamily: 'arial'),
                  ),
                  Text(
                    "$totalprice  ${'da'.tr}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontFamily: 'arial'),
                  ),
                ],
              ),
            ),
          ),
          // CustomButtonCart(
          //   textbutton: "checkout".tr,
          //   onPressed: () {
          //     controller.goToPageCheckout();
          //   },
          // ),
        ],
      ),
    );
  }
}
