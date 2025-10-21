import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:softel/core/constant/color.dart';

class Loadingwidget extends StatelessWidget {
  final double width; // ✅ Non-nullable

  const Loadingwidget({super.key, this.width = 10}); // ✅ default value is safe

  @override
  Widget build(BuildContext context) {
    // Use local variable for calculation
    final double effectiveWidth = width == 10 ? Get.width * 0.5 : width;

    return Center(
      child: Lottie.asset(
        'assets/lottie/Loading_lottie.json',
        fit: BoxFit.fitWidth,
        width: effectiveWidth,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(['Rectangle_1', 'Rectangle 1', 'Fill 1'], value: AppColor.primaryColor),
            ValueDelegate.color(['Rectangle_2', 'Rectangle 1', 'Fill 1'], value: AppColor.companySecendColor),
            ValueDelegate.color(['Rectangle_3', 'Rectangle 1', 'Fill 1'], value: AppColor.primaryColor),
            ValueDelegate.color(['Rectangle_4', 'Rectangle 1', 'Fill 1'], value: AppColor.companySecendColor),
          ],
        ),
      ),
    );
  }
}

// class DynamicLottieLoader extends StatelessWidget {
//   final Color color1;
//   final Color color2;
//   final Color color3;
//   final Color color4;

//   const DynamicLottieLoader({super.key, required this.color1, required this.color2, required this.color3, required this.color4});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Lottie.asset(
//         'assets/lottie/Loading_lottie.json',
//         delegates: LottieDelegates(
//           values: [
//             // Target each rectangle layer’s fill color
//             ValueDelegate.color(['Rectangle_1', 'Rectangle 1', 'Fill 1'], value: color1),
//             ValueDelegate.color(['Rectangle_2', 'Rectangle 1', 'Fill 1'], value: color2),
//             ValueDelegate.color(['Rectangle_3', 'Rectangle 1', 'Fill 1'], value: color3),
//             ValueDelegate.color(['Rectangle_4', 'Rectangle 1', 'Fill 1'], value: color4),
//           ],
//         ),
//       ),
//     );
//   }
// }
