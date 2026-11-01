import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching [GlassmorphismCartItem] and [GlassmorphismCartItemTraking].
class CartItemShimmer extends StatelessWidget {
  final int itemCount;

  const CartItemShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.04 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ShimmerBase(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image Placeholder (120x150)
                const ShimmerBox(
                  width: 110,
                  height: 140,
                  borderRadius: 16,
                ),
                const SizedBox(width: 12),

                // Details Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
                      SizedBox(height: 6),
                      ShimmerBox(width: 120, height: 14, borderRadius: 4),
                      SizedBox(height: 16),
                      ShimmerBox(width: 140, height: 14, borderRadius: 4),
                      SizedBox(height: 12),
                      ShimmerBox(width: 100, height: 16, borderRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Action buttons placeholder
                Column(
                  children: [
                    ShimmerBox.circle(size: 28),
                    const SizedBox(height: 12),
                    ShimmerBox.circle(size: 28),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
