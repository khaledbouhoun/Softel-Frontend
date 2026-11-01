import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/product_card_shimmer.dart';

/// Shimmer skeleton matching the [ProductGrid] 2-column layout.
///
/// Uses the exact grid delegate, spacing, and aspect ratio of the real product grid
/// to eliminate layout jumping when product data arrives.
class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 6,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ProductCardShimmer();
      },
    );
  }
}
