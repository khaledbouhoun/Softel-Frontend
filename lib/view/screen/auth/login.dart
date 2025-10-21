import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:softel/controller/auth/login_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/view/widget/loadingwidget.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: Loadingwidget());
          }

          return SafeArea(
            child: Column(
              children: [
                // scrollable content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ✅ Company Logo
                        Hero(
                          tag: controller.company!.clsNo!,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: controller.company!.clsImg ?? '',
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: controller.company!.clsClr1)),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(AppSvg.galleryremove, color: controller.company!.clsClr1, width: 60),
                            ),
                          ),
                        ),

                        const SizedBox(height: 200),

                        // ✅ Sign-In Button
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColor.primaryColor),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                onPressed: () => controller.loginWithGoogle(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: Directionality.of(context),
                                  children: [
                                    Text(
                                      "google".tr,
                                      style: TextStyle(color: AppColor.primaryColor, fontSize: 17, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 14),
                                    Image.asset(AppImageAsset.google, height: 30),
                                    // SvgPicture.asset(AppSvg.googletext, width: 50, height: 50),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ Footer fixed at bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("powered_by".tr, style: TextStyle(color: AppColor.primaryColor, fontSize: 16)),
                      const SizedBox(width: 8),
                      Image.asset(AppImageAsset.logo, height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
