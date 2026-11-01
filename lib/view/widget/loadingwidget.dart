import 'package:flutter/material.dart';
import 'package:softel/view/widget/loading/app_loading_indicator.dart';

/// Legacy loading widget maintained for backward compatibility.
///
/// Prefer using [AppLoadingIndicator] for blocking actions, or specific
/// shimmer skeletons (e.g. `ProductGridShimmer`, `BannerShimmer`) for data loading.
class Loadingwidget extends StatelessWidget {
  final double width;

  const Loadingwidget({super.key, this.width = 10});

  @override
  Widget build(BuildContext context) {
    return AppLoadingIndicator(
      width: width == 10 ? null : width,
    );
  }
}
