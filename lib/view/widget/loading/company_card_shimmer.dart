import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching [CompanyWidget] in company selection screen.
class CompanyCardShimmer extends StatelessWidget {
  final int itemCount;

  const CompanyCardShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.04 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ShimmerBase(
            child: Stack(
              children: [
                // Centered logo placeholder
                const Center(
                  child: ShimmerBox(
                    width: 140,
                    height: 80,
                    borderRadius: 12,
                  ),
                ),

                // Bottom title placeholder
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: const ShimmerBox(
                    width: 120,
                    height: 18,
                    borderRadius: 6,
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
