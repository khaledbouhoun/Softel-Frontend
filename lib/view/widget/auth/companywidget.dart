import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/data/model/company.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget({super.key, required this.company, required this.ontap});

  final Company company;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: AppColor.primaryColor.withOpacity(0.2),
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          // Gradient border layer
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: company.clsClr1!.withOpacity(0.8), width: 2),
        ),
        padding: const EdgeInsets.all(2), // Border thickness
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: company.clsClr1!.withOpacity(0.5), blurRadius: 15, spreadRadius: 2, offset: const Offset(4, 4))],
          ),
          padding: const EdgeInsets.all(12),
          child: Hero(
            tag: company.clsNo!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: company.clsImg ?? '',
                fit: BoxFit.fitWidth,
                width: double.infinity,
                placeholder: (context, url) => SizedBox(),
                errorWidget: (context, url, error) => SvgPicture.asset(AppSvg.galleryremove, color: AppColor.primaryColor, width: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
