import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:softel/data/model/company.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget({super.key, required this.company, required this.ontap});

  final Company company;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: ontap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              /// 🖼 LOGO AREA (clean & centered)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Hero(
                    tag: company.clsNo!,
                    child: CachedNetworkImage(
                      imageUrl: company.clsImg ?? '',
                      fit: BoxFit.contain, // ✅ FIXED
                      placeholder: (context, url) => CircularProgressIndicator(color: company.clsClr1),
                      errorWidget: (context, url, error) => Text(
                        company.clsNom ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: company.clsClr1, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🌑 SOFT BOTTOM GRADIENT (modern)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, company.clsClr1!.withValues(alpha: 0.4)],
                    ),
                  ),
                ),
              ),

              /// 🏷 TITLE
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Text(
                  company.clsNom ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
