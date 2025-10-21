import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/controller/cart/cart_controller.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  final String? logoUrl;
  const TopBar({super.key, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text('Ecommerce-Logo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          CachedNetworkImage(
            imageUrl: logoUrl ?? '',
            height: 40,
            width: 120,
            placeholder: (context, url) => SizedBox(),
            errorWidget: (context, url, error) => Image.asset(AppImageAsset.logo),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoute.cart);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // أيقونة السلة
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AppSvg.cart2, color: AppColor.primaryColor, width: 32, height: 32),
                ),

                // العداد (Badge)
                GetBuilder<HomeController>(
                  init: HomeController(),
                  builder: (controller) {
                    return controller.cartcount > 0
                        ? Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(1, 2))],
                              ),
                              child: Text(
                                '${controller.cartcount}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
