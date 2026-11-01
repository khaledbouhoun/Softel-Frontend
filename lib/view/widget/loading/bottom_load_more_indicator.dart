import 'package:flutter/material.dart';
import 'package:softel/core/constant/color.dart';

/// Compact indicator shown at the bottom of lists/grids during pagination (load more).
///
/// Ensures loaded content remains visible while fetching subsequent pages.
class BottomLoadMoreIndicator extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;
  final double strokeWidth;
  final Color? color;

  const BottomLoadMoreIndicator({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
    this.size = 24.0,
    this.strokeWidth = 2.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColor.primaryColor),
          ),
        ),
      ),
    );
  }
}
