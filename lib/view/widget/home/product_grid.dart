import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/view/widget/loading/bottom_load_more_indicator.dart';
import 'package:softel/view/widget/loading/product_grid_shimmer.dart';

class ProductGrid extends StatelessWidget {
  final dynamic isloadingProducts;
  final bool isLoadingProducts;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final List<Product> products;
  final void Function(int) onTap;
  final ScrollPhysics? physics;
  final ScrollController? scrollercontroller;
  final bool enableScroll;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onTap,
    this.isloadingProducts,
    this.isLoadingProducts = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.physics,
    this.scrollercontroller,
    this.enableScroll = false,
  });

  bool get _isLoading {
    if (isloadingProducts is RxBool || isloadingProducts is Rx<bool>) {
      return (isloadingProducts as Rx<bool>).value;
    }
    if (isloadingProducts is bool) {
      return isloadingProducts as bool;
    }
    return isLoadingProducts;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Initial full-data loading state: products is empty and loading
    if (_isLoading && products.isEmpty) {
      return const ProductGridShimmer();
    }

    // 2. Grid content with products
    Widget gridContent = Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (context, i) {
            return productCard(products[i], onTap: () => onTap(i));
          },
        ),
        // 🔄 Pagination / Status state
        _buildBottomStatus(),
      ],
    );

    if (!enableScroll) {
      return gridContent;
    }

    return SingleChildScrollView(
      controller: scrollercontroller,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      child: gridContent,
    );
  }

  Widget _buildBottomStatus() {
    if (isLoadingMore) {
      return const BottomLoadMoreIndicator();
    } else if (hasReachedEnd) {
      return _buildEndMessage();
    }
    return const SizedBox(height: 20);
  }

  Widget _buildEndMessage() {
    if (hasReachedEnd) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            products.isEmpty ? 'no_products'.tr : 'no_more_products'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 102, 102, 102),
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 20);
  }
}

Widget productCard(Product p, {required void Function()? onTap}) {
  final hasQuantity = p.artQte != null && p.artQte! > 0;
  final formattedQuantity = hasQuantity
      ? (p.artQte! % 1 == 0 ? p.artQte!.toInt().toString() : p.artQte!.toString())
      : '';

  return Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return GestureDetector(
        key: ValueKey('product_${p.artNo}_${p.artQte}'),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.grey.withValues(alpha: isDark ? 0.2 : 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          fit: BoxFit.scaleDown,
                          imageUrl: (p.artImages != null && p.artImages!.isNotEmpty) ? (p.artImages!.first.imgNom ?? '') : '',
                          placeholder: (context, url) => const SizedBox(),
                          errorWidget: (context, url, error) => const SizedBox(),
                        ),
                      ),
                    ),
                    if (hasQuantity)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                p.artQte.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${p.artPrix} DA',
                          style: const TextStyle(
                            color: AppColor.prixColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SvgPicture.asset(
                            AppSvg.cart,
                            width: 10,
                            height: 10,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
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
