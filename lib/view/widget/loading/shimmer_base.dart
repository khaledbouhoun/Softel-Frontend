import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base Shimmer widget that wraps content in a shimmer effect.
///
/// Automatically adapts base and highlight colors to Light and Dark mode.
class ShimmerBase extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const ShimmerBase({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color effectiveBaseColor = baseColor ??
        (isDark ? const Color(0xFF262626) : const Color(0xFFE5E7EB));

    final Color effectiveHighlightColor = highlightColor ??
        (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF3F4F6));

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      period: period,
      child: child,
    );
  }
}
