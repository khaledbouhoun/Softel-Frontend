import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching order cards in [Traking] screen.
class OrderCardShimmer extends StatelessWidget {
  final int itemCount;

  const OrderCardShimmer({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.04 : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ShimmerBase(
            child: Column(
              children: [
                Row(
                  children: [
                    // Status icon placeholder (60x60, radius 15)
                    const ShimmerBox(
                      width: 60,
                      height: 60,
                      borderRadius: 15,
                    ),
                    const SizedBox(width: 16),

                    // Order ID & status badge placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerBox(
                            width: 120,
                            height: 18,
                            borderRadius: 4,
                          ),
                          SizedBox(height: 10),
                          ShimmerBox(
                            width: 90,
                            height: 24,
                            borderRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBox(width: 80, height: 14, borderRadius: 4),
                    ShimmerBox(width: 100, height: 16, borderRadius: 4),
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
