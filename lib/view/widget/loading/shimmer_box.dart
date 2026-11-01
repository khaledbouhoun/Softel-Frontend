import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';

/// Reusable shimmer placeholder box for texts, images, buttons, and cards.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool wrapWithShimmer;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
    this.margin,
    this.padding,
    this.color,
    this.wrapWithShimmer = false,
  });

  /// Factory constructor for circular shimmer placeholders (e.g. avatars, icons).
  factory ShimmerBox.circle({
    Key? key,
    required double size,
    EdgeInsetsGeometry? margin,
    Color? color,
    bool wrapWithShimmer = false,
  }) {
    return ShimmerBox(
      key: key,
      width: size,
      height: size,
      shape: BoxShape.circle,
      margin: margin,
      color: color,
      wrapWithShimmer: wrapWithShimmer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget box = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      ),
    );

    if (wrapWithShimmer) {
      return ShimmerBase(child: box);
    }

    return box;
  }
}
