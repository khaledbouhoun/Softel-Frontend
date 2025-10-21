import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/controller/settings/settings_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Section with Gradient
                Container(
                  alignment: Alignment.center,
                  height: 250,
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColor.primaryColor, AppColor.primaryColor.withOpacity(0.8)],
                    ),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Pattern
                      Positioned(
                        top: 50,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: -30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            // Profile Avatar
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl: controller.photoUrl,
                                imageBuilder: (context, imageProvider) => CircleAvatar(radius: 58, backgroundImage: imageProvider),
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 58,
                                  backgroundColor: Colors.white,
                                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 58,
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // User Name
                            Text(
                              controller.nom,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'DeliusSwashCaps',
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 2), blurRadius: 4)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Settings Sections
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Settings Section
                      _buildSectionTitle('setting'.tr),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildSettingsItem(
                          icon: AppSvg.language,
                          title: 'language'.tr,
                          subtitle: 'language_text'.tr,
                          onTap: () => Get.toNamed(AppRoute.languagechange),
                        ),
                        _buildDivider(),
                        _buildSettingsItem(
                          icon: AppSvg.share,
                          title: 'share_app'.tr,
                          subtitle: 'share_app_text'.tr,
                          onTap: () {
                            const String packageName = "com.yourcompany.softel";
                            const String appLink = "https://play.google.com/store/apps/details?id=$packageName";
                            const String shareText = "Check out this awesome E-commerce App!\n$appLink";
                            Share.share(shareText, subject: 'Look what I found!');
                          },
                        ),
                      ]),

                      const SizedBox(height: 25),

                      // Support Section
                      _buildSectionTitle('support'.tr),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildSettingsItem(
                          icon: AppSvg.socialmedia,
                          title: 'social_media'.tr,
                          subtitle: 'social_media_text'.tr,
                          onTap: () => _showSocialMediaBottomSheet(context, controller),
                        ),
                        _buildSettingsItem(
                          icon: AppSvg.call,
                          title: 'contact_us'.tr,
                          subtitle: 'contact_us_text'.tr,
                          onTap: () => _showContactBottomSheet(context, controller),
                        ),
                      ]),

                      const SizedBox(height: 40),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: isDestructive ? Colors.red.withOpacity(0.1) : AppColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(icon, width: 30, height: 30, color: isDestructive ? Colors.red : AppColor.primaryColor),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  void _showContactBottomSheet(BuildContext context, SettingsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: Get.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'contact_us'.tr,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'contact_us_text'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // WhatsApp Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                child: _buildWhatsAppNumber(controller.whatsapp),
              ),

              const SizedBox(height: 20),

              // Social Media Section
            ],
          ),
        );
      },
    );
  }

  void _showSocialMediaBottomSheet(BuildContext context, SettingsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: Get.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'social_media'.tr,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'social_media_text'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSocialMediaItem(SvgPicture.asset(AppSvg.facebook), "Facebook", controller.facebook),
                      const SizedBox(height: 15),
                      _buildSocialMediaItem(SvgPicture.asset(AppSvg.instagram), "Instagram", controller.instagram),
                      const SizedBox(height: 15),
                      _buildSocialMediaItem(SvgPicture.asset(AppSvg.tiktok), "TikTok", controller.tiktok),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Social Media Section
            ],
          ),
        );
      },
    );
  }

  Widget _buildWhatsAppNumber(String phoneNumber) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse('https://wa.me/$phoneNumber'));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(margin: const EdgeInsets.only(right: 16), child: SvgPicture.asset(AppSvg.whatsapp)),
            Text(phoneNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaItem(Widget icon, String title, String url) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse(url));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: icon,
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
