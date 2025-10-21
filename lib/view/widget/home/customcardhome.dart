import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/controller/home/home_controller.dart';
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

class CustomCardHome extends GetView<HomeController> {
  final List<ImagesBanner> images;
  // final List <String> images;
  const CustomCardHome({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel.builder(
      options: FlutterCarouselOptions(
        height: Get.width * 0.4,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        enlargeCenterPage: true,

        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enableInfiniteScroll: true,
        // pagination: true,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: images.isEmpty
            ? SvgPicture.asset(AppSvg.galleryremove, width: double.infinity, color: AppColor.primaryColor, fit: BoxFit.fitHeight)
            : InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoute.famillesdetailes,
                    arguments: {
                      "famille": Familles(famNo: images[itemIndex].imgFam, famNom: "", famImg: ""),
                      "soufamille": SouFamilles(souNo: images[itemIndex].imgSFam, souNom: images[itemIndex].imgSFamNom),
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    // height: Get.width * 0.4,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    imageUrl: images[itemIndex].imgNom!,
                    placeholder: (context, url) => SizedBox(),
                    errorWidget: (context, url, error) =>
                        SvgPicture.asset(AppSvg.galleryremove, width: double.infinity, color: AppColor.primaryColor, fit: BoxFit.fitHeight),
                  ),
                ),
              ),
      ),
    );
  }
}
