import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/linkapi.dart';
import 'package:flutter/material.dart';

class FamillesGrid extends StatelessWidget {
  const FamillesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FamillesController>(
      init: FamillesController(),
      builder: (controller) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2,
          ),
          itemCount: controller.filteredfamilles.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => controller.goToCategoreis(controller.filteredfamilles[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: const Color.fromARGB(255, 0, 88, 129).withOpacity(0.10), blurRadius: 18, offset: const Offset(0, 8)),
                  ],
                  border: Border.all(color: AppColor.primaryColor.withOpacity(0.13), width: 1.2),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          height: 150,
                          width: 150,
                          // imageUrl: "${AppLink.familleImage}${controller.filteredfamilles[i].famImg}",
                          imageUrl: "${controller.filteredfamilles[i].famImg}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SizedBox(),
                          errorWidget: (context, url, error) => SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.filteredfamilles[i].famNom ?? "",
                              style:  TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                              maxLines: 3,
                            ),
                            // Optionally add a subtitle or description here
                            // Text(cat.description ?? '', style: TextStyle(...)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        backgroundColor: AppColor.primaryColor.withOpacity(0.85),
                        radius: 18,
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
