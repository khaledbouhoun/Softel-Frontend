import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:softel/core/constant/color.dart';

/// Generic centered Lottie indicator reserved strictly for indeterminate,
/// action-blocking, or splash loading states (NOT for page data skeleton loading).
class AppLoadingIndicator extends StatelessWidget {
  final double? width;

  const AppLoadingIndicator({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveWidth = width ?? (Get.width * 0.4);

    return Center(
      child: Lottie.asset(
        'assets/lottie/Loading_lottie.json',
        fit: BoxFit.fitWidth,
        width: effectiveWidth,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(
              ['Rectangle_1', 'Rectangle 1', 'Fill 1'],
              value: AppColor.primaryColor,
            ),
            ValueDelegate.color(
              ['Rectangle_2', 'Rectangle 1', 'Fill 1'],
              value: AppColor.companySecendColor,
            ),
            ValueDelegate.color(
              ['Rectangle_3', 'Rectangle 1', 'Fill 1'],
              value: AppColor.primaryColor,
            ),
            ValueDelegate.color(
              ['Rectangle_4', 'Rectangle 1', 'Fill 1'],
              value: AppColor.companySecendColor,
            ),
          ],
        ),
      ),
    );
  }
}
