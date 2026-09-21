import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/data/model/familles.dart';

class FamilleSelector extends StatelessWidget {
  final List<FamilleItem> famillesItems;
  final Familles? selectedFamille;
  final void Function(Familles famille)? onSelectFamille;

  const FamilleSelector({
    super.key,
    required this.famillesItems,
    this.selectedFamille,
    this.onSelectFamille,
  });

  @override
  Widget build(BuildContext context) {
    final currentSelectedId = selectedFamille?.famNo ??
        (Get.isRegistered<HomeController>() ? Get.find<HomeController>().selectedFamille.value.famNo : null);

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: famillesItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = famillesItems[i];
          final isSelected = currentSelectedId == item.famille.famNo;

          return GestureDetector(
            onTap: () {
              if (onSelectFamille != null) {
                onSelectFamille!(item.famille);
              } else if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().selectFamille(item.famille);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColor.primaryColor : Colors.grey.shade200),
                boxShadow: isSelected ? [BoxShadow(color: AppColor.primaryColor.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))] : [],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    item.svg,
                    colorFilter: ColorFilter.mode(isSelected ? Colors.white : AppColor.primaryColor, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.famille.famNom ?? '',
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FamilleItem {
  final Familles famille;
  final String svg;
  FamilleItem(this.famille, this.svg);
}
