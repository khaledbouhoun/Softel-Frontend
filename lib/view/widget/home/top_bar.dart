import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';

class TopBar extends StatelessWidget {
  final String? logoUrl;
  final int cartCount;

  const TopBar({super.key, required this.logoUrl, required this.cartCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ----------------------------------------------------------
          // Logo
          // ----------------------------------------------------------
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 120,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: logoUrl ?? '',
                  width: 120,
                  height: 40,
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return Image.asset(AppImageAsset.logo, width: 120, height: 40, fit: BoxFit.contain);
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(AppImageAsset.logo, width: 120, height: 40, fit: BoxFit.contain);
                  },
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // Cart
          // ----------------------------------------------------------
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Get.toNamed(AppRoute.cart);
            },
            child: SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cart icon
                  Center(
                    child: SvgPicture.asset(
                      AppSvg.cart2,
                      width: 32,
                      height: 32,
                      colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                    ),
                  ),

                  // Cart badge
                  if (cartCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(1, 2))],
                        ),
                        child: Text(
                          '$cartCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
