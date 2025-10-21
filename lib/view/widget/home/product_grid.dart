import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/data/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(int) onTap;
  final ScrollPhysics? physics;
  final ScrollController? scrollercontroller;

  const ProductGrid({super.key, required this.products, required this.onTap, this.physics, this.scrollercontroller});

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? const Center(child: Text("No products found"))
        : GridView.builder(
            shrinkWrap: true,
            physics: physics ?? const NeverScrollableScrollPhysics(),
            controller: scrollercontroller,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () {
                  if (i >= 0 && i < products.length) {
                    onTap(i);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColor.grey.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'product_${p.artNo}',
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: p.artImages != null && p.artImages!.isNotEmpty
                                    ? CachedNetworkImage(
                                        fit: BoxFit.scaleDown,
                                        imageUrl: p.artImages!.first.imgNom!,
                                        placeholder: (context, url) => SizedBox(),

                                        errorWidget: (context, url, error) => Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: SvgPicture.asset(
                                            AppSvg.galleryremove,
                                            color: AppColor.primaryColor,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SvgPicture.asset(
                                          AppSvg.galleryremove,
                                          color: AppColor.primaryColor,
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                              ),
                            ),
                            if (p.artQte != null && p.artQte! > 0)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${p.artQte!.toInt()}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.artNom ?? '',

                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, overflow: TextOverflow.ellipsis),
                              maxLines: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${p.artPrix} DA',
                                  style: const TextStyle(color: AppColor.prixColor, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Container(
                                  width: 45,
                                  height: 45,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(14)),
                                  child: SvgPicture.asset(AppSvg.cart, width: 10, height: 10, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
