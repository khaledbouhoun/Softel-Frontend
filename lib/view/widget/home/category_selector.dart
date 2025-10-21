import 'package:softel/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FamilleItem {
  final String label;
  final String svg;
  FamilleItem(this.label, this.svg);
}

class FamilleSelector extends StatelessWidget {
  final List<FamilleItem> familles;
  final int selectedIndex;
  final ValueChanged<int> onfamilleSelected;
  const FamilleSelector({super.key, required this.familles, required this.selectedIndex, required this.onfamilleSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: familles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final cat = familles[i];
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onfamilleSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColor.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppColor.primaryColor : Colors.grey.shade200),
                boxShadow: selected ? [BoxShadow(color: AppColor.primaryColor.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 2))] : [],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(cat.svg, color: selected ? Colors.white : AppColor.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    cat.label,
                    style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
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
