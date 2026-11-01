import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';

/// Shimmer skeleton matching the [CustomCardHome] banner widget.
class BannerShimmer extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const BannerShimmer({
    super.key,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? (MediaQuery.sizeOf(context).width * 0.4);

    return Padding(
      padding: padding,
      child: ShimmerBase(
        child: ShimmerBox(
          width: double.infinity,
          height: effectiveHeight,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
