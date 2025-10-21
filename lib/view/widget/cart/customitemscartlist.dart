import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/data/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GlassmorphismCartItem extends StatelessWidget {
  final CartModel cart;
  final String imagename;
  final void Function()? onPressed, onRemove;
  const GlassmorphismCartItem({super.key, required this.cart, required this.imagename, required this.onRemove, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.07), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'product_${cart.cddArtNo}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      //  imagename.isEmpty
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: SvgPicture.asset(color: AppColor.primaryColor, AppSvg.galleryremove, height: 110, fit: BoxFit.cover),
                      //       )
                      //     :
                      CachedNetworkImage(
                        imageUrl: 'https://www.pngall.com/wp-content/uploads/16/iPhone-16-Pro-Max-PNG.png',
                        fit: BoxFit.scaleDown,
                        height: 170,
                        width: 120,
                        errorWidget: (context, url, error) => SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor),
                      ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart.cddArtNom ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('qty'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        SizedBox(width: 4),
                        Text(cart.cddQte?.toStringAsFixed(0) ?? '0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(width: 16),
                        Text('price'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        SizedBox(width: 4),
                        Text(
                          cart.cddPrix?.toStringAsFixed(2) ?? '0.00',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColor.primaryColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('total'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        SizedBox(width: 4),
                        Text(
                          '${cart.cddMontant?.toStringAsFixed(2) ?? '0.00'} ${'da'.tr}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: SvgPicture.asset(AppSvg.edit3, color: AppColor.primaryColor, height: 20, width: 20),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: SvgPicture.asset(AppSvg.trashBin, color: AppColor.warning, height: 22, width: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GlassmorphismCartItemTraking extends StatelessWidget {
  final CartModel cart;
  final String imagename;
  const GlassmorphismCartItemTraking({super.key, required this.cart, required this.imagename});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        border: Border.all(color: AppColor.primaryColor.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.07), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'product_${cart.cddArtNo}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  //  imagename.isEmpty
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: SvgPicture.asset(color: AppColor.primaryColor, AppSvg.galleryremove, height: 110, fit: BoxFit.cover),
                  //       )
                  //     :
                  CachedNetworkImage(
                    imageUrl: 'https://www.pngall.com/wp-content/uploads/16/iPhone-16-Pro-Max-PNG.png',
                    fit: BoxFit.scaleDown,
                    height: 170,
                    width: 120,
                    errorWidget: (context, url, error) => SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor),
                  ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.cddArtNom ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(cart.cddArtUni ?? '', style: TextStyle(color: AppColor.secondaryColor, fontSize: 14)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('qty'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(width: 4),
                    Text(cart.cddQte?.toStringAsFixed(0) ?? '0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 16),
                    Text('price'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(width: 4),
                    Text(
                      cart.cddPrix?.toStringAsFixed(2) ?? '0.00',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColor.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('total'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(width: 4),
                    Text(
                      '${cart.cddMontant?.toStringAsFixed(2) ?? '0.00'} ${'da'.tr}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
