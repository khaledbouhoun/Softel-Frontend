import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching the horizontal [FamilleSelector] category pills.
class CategoryShimmer extends StatelessWidget {
  final int itemCount;

  const CategoryShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    // Varied pill widths to look natural like real category labels
    final pillWidths = [110.0, 130.0, 95.0, 120.0, 105.0];

    return SizedBox(
      height: 60,
      child: ShimmerBase(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final width = pillWidths[index % pillWidths.length];
            return Center(
              child: ShimmerBox(
                width: width,
                height: 44,
                borderRadius: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
