import 'package:flutter/material.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching the exact layout and dimensions of [productCard].
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: isDark ? 0.15 : 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ShimmerBase(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Product Image Placeholder
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 16,
                ),
              ),
            ),

            // Product Details Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name Line 1
                  const ShimmerBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 6),

                  // Product Name Line 2
                  const ShimmerBox(
                    width: 90,
                    height: 12,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 10),

                  // Price and Cart Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      // Price Placeholder
                      ShimmerBox(
                        width: 70,
                        height: 20,
                        borderRadius: 6,
                      ),

                      // Cart Action Button Placeholder (45x45, radius 14)
                      ShimmerBox(
                        width: 45,
                        height: 45,
                        borderRadius: 14,
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
  }
}
