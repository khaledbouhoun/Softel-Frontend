import 'package:flutter/material.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching [FamillesGrid] and [SoufamillesGrid].
class FamillesGridShimmer extends StatelessWidget {
  final int itemCount;

  const FamillesGridShimmer({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColor.primaryColor.withValues(alpha: 0.13),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 88, 129).withValues(alpha: isDark ? 0.05 : 0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ShimmerBase(
            child: Row(
              children: [
                // Image box placeholder
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: ShimmerBox(
                    width: 150,
                    height: 150,
                    borderRadius: 18,
                  ),
                ),

                // Title lines placeholder
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ShimmerBox(
                          width: double.infinity,
                          height: 18,
                          borderRadius: 4,
                        ),
                        SizedBox(height: 8),
                        ShimmerBox(
                          width: 80,
                          height: 14,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // Trailing circle arrow avatar placeholder
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ShimmerBox.circle(
                    size: 36,
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
