import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/controller/cart/cart_controller.dart';
import 'package:softel/controller/product/productdetails_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // final mockImages = [
    //   'https://images.unsplash.com/photo-1513708927688-890fe41c3b6c',
    //   'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    //   'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
    // ];
    // final productImages = (product.images.isNotEmpty) ? [...product.images.map((img) => '${AppLink.imagestproducts}$img')] : [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Backwidget(),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            onPressed: () async {
              Get.lazyPut(() => CartController());
              print("------------------ top bar controller");
              await Get.find<CartController>().view();
              Get.offNamed(AppRoute.cart);
            },
            icon: SvgPicture.asset(AppSvg.cart, color: AppColor.primaryColor, width: 28, height: 28),
          ),
        ],
      ),
      backgroundColor: AppColor.background,
      body: GetBuilder<ProductDetailsController>(
        init: ProductDetailsController(),
        builder: (controller) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Product Image Carousel with Discount Badge ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: FlutterCarousel(
                    options: FlutterCarouselOptions(
                      height: Get.height * 0.3,
                      viewportFraction: 1.0,
                      showIndicator: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: (controller.product.artImages ?? []).isNotEmpty
                        ? (controller.product.artImages ?? [])
                              .map(
                                (img) => Hero(
                                  tag: 'product_${controller.product.artNo ?? ''}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    child: (img.imgNom ?? '') == ''
                                        ? SvgPicture.asset(
                                            AppSvg.galleryremove,
                                            width: double.infinity,
                                            height: Get.height * 0.3,
                                            color: AppColor.primaryColor,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: img.imgNom ?? '',
                                            fit: BoxFit.scaleDown,
                                            height: Get.height * 0.3,
                                            width: double.infinity,
                                            placeholder: (context, url) => SizedBox(),
                                            errorWidget: (context, url, error) =>
                                                SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor),
                                          ),
                                  ),
                                ),
                              )
                              .toList()
                        : [
                            SvgPicture.asset(
                              AppSvg.galleryremove,
                              width: double.infinity,
                              height: Get.height * 0.3,
                              color: AppColor.primaryColor,
                              fit: BoxFit.cover,
                            ),
                          ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Text(
                          controller.product.artNom ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()),

                      Expanded(
                        flex: 5,
                        child: Text(
                          '${controller.product.artPrix ?? ''}  ${'da'.tr}',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: ToggleButtons(
                      onPressed: (index) => controller.toggleUnitType(index),
                      isSelected: (controller.product.artColisageNom ?? '').isNotEmpty
                          ? [controller.isUnitSelected, !controller.isUnitSelected]
                          : [controller.isUnitSelected],
                      fillColor: AppColor.primaryColor.withOpacity(0.15),
                      selectedColor: AppColor.primaryColor,
                      color: Colors.grey.shade600,
                      borderColor: Colors.transparent,
                      selectedBorderColor: AppColor.primaryColor,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(16),
                      constraints: BoxConstraints(minHeight: 50, minWidth: Get.width * 0.4),
                      children: (controller.product.artColisageNom ?? '').isNotEmpty
                          ? <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(children: [Text('par_unite'.tr)]),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(children: [Text('par_colis'.tr)]),
                              ),
                            ]
                          : [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(children: [Text('unite'.tr)]),
                              ),
                            ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(AppSvg.subtractCircle, color: Colors.black, width: 28, height: 28),
                            onPressed: controller.decrementQty,
                            onLongPress: () => controller.decrementQtyHold(),
                          ),
                          GestureDetector(
                            onTap: () {
                              double? tempQty = controller.qtyinput.value;
                              final qtyController = TextEditingController(text: tempQty.toString());
                              String? errorText;
                              Get.defaultDialog(
                                backgroundColor: Colors.white,
                                title: 'enrter_quantity'.tr,
                                content: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    cursorColor: AppColor.primaryColor,
                                    autofocus: true,
                                    controller: qtyController,
                                    style: TextStyle(color: AppColor.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppColor.primaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppColor.primaryColor),
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppColor.primaryColor),
                                      ),
                                      errorText: errorText,
                                    ),
                                    onChanged: (_) => errorText = null,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Get.back(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade400,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text('cancel'.tr, style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (qtyController.text.isNotEmpty) {
                                        double qty = double.parse(qtyController.text);
                                        if (qty > 0) {
                                          controller.qtyinput.value = qty;
                                          controller.calculate();
                                        }
                                      }
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text('confirm'.tr, style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                            child: Obx(
                              () => Text(
                                controller.qtyinput.value.toString(),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(AppSvg.addCircle, color: Colors.black, width: 28, height: 28),
                            onPressed: controller.incrementQty,
                          ),
                        ],
                      ),
                      Obx(
                        () => Text(
                          '${controller.totalprice.value} ${'da'.tr}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: (controller.product.artColisageNom ?? '').isNotEmpty,
                  child: Column(
                    children: [
                      const Divider(endIndent: 30, indent: 30),
                      if (controller.isUnitSelected)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'colis'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                              ),
                              Obx(
                                () => Text(
                                  '${controller.coulis.value}   ${(controller.product.artColisageNom ?? '')}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'unite'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                            ),
                            Obx(
                              () => Text(
                                '${controller.unites.value}   ${(controller.product.artUni ?? '')}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GetBuilder<ProductDetailsController>(
        init: ProductDetailsController(),
        builder: (controller) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.totalprice.value == 0.0
                        ? controller.product.artQte == 0
                              ? Colors.grey.shade400
                              : const Color.fromARGB(255, 185, 12, 0)
                        : AppColor.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // elevation: 10,
                    elevation: 8,
                  ),
                  onPressed: () {
                    if (controller.totalprice.value > 0.0) {
                      controller.storeCommand();
                    } else {
                      if (controller.product.artQte != 0) {
                        controller.deletefromcart();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: controller.isloading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : controller.totalprice.value == 0.0
                        ? controller.product.artQte == 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 20,

                                  children: [
                                    SvgPicture.asset(AppSvg.cartPlus, color: Colors.white, width: 28, height: 28),

                                    Text(
                                      'should_enter_quantity'.tr,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 24,
                                  child: Text(
                                    'delete_from_cart'.tr,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              SvgPicture.asset(AppSvg.cartPlus, color: Colors.white, width: 28, height: 28),
                              Text(
                                'add_to_cart'.tr,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
