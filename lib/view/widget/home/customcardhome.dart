import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/imagesbanner.dart';
import 'package:softel/data/model/soufamilles.dart';

class CustomCardHome extends StatelessWidget {
  final List<ImagesBanner> images;
  final bool isLoading;

  const CustomCardHome({
    super.key,
    required this.images,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: Get.width * 0.4,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return FlutterCarousel.builder(
      options: FlutterCarouselOptions(
        height: Get.width * 0.4,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enableInfiniteScroll: images.length > 1,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final banner = images[itemIndex];
        final imageUrl = banner.imgNom ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: imageUrl.isEmpty
              ? SvgPicture.asset(
                  AppSvg.galleryremove,
                  width: double.infinity,
                  colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                  fit: BoxFit.fitHeight,
                )
              : InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.famillesdetailes,
                      arguments: {
                        "famille": Familles(famNo: banner.imgFam ?? '', famNom: "", famImg: ""),
                        "soufamille": SouFamilles(souNo: banner.imgSFam ?? '', souNom: banner.imgSFamNom ?? ''),
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) => SvgPicture.asset(
                        AppSvg.galleryremove,
                        width: double.infinity,
                        colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
