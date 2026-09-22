import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/view/widget/home/category_selector.dart';

class MockHomeControllerForCategory extends GetxController {
  final familleItems = <FamilleItem>[].obs;
  final selectedFamille = Rx<Familles>(Familles(famNo: '00', famNom: 'All'));

  void populateFamilles() {
    final allFamille = Familles(famNo: '00', famNom: 'All');
    final items = [
      FamilleItem(allFamille, AppSvg.widget2Filled),
      FamilleItem(Familles(famNo: '01', famNom: 'Stocks'), AppSvg.widget2),
      FamilleItem(Familles(famNo: '02', famNom: 'Test'), AppSvg.widget2),
    ];
    familleItems.assignAll(items);
  }
}

void main() {
  testWidgets('Passing controller.familleItems directly fails to rebuild Obx', (tester) async {
    final controller = MockHomeControllerForCategory();
    int rebuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Obx(() {
            rebuildCount++;
            return FamilleSelector(
              famillesItems: controller.familleItems, // Notice: NOT .toList()
              selectedFamille: controller.selectedFamille.value,
              onSelectFamille: (_) {},
            );
          }),
        ),
      ),
    );

    expect(rebuildCount, 1);
    expect(find.text('Stocks'), findsNothing);

    // Now API finishes and populates items:
    controller.populateFamilles();
    await tester.pump();

    // Rebuild count will STILL be 1 because Obx never subscribed to familleItems!
    expect(rebuildCount, 1); // Fails to rebuild!
    expect(find.text('Stocks'), findsNothing); // Stocks is NOT shown!
  });

  testWidgets('Passing controller.familleItems.toList() immediately rebuilds Obx', (tester) async {
    final controller = MockHomeControllerForCategory();
    int rebuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Obx(() {
            rebuildCount++;
            return FamilleSelector(
              famillesItems: controller.familleItems.toList(), // Notice: .toList()
              selectedFamille: controller.selectedFamille.value,
              onSelectFamille: (_) {},
            );
          }),
        ),
      ),
    );

    expect(rebuildCount, 1);
    expect(find.text('Stocks'), findsNothing);

    // Now API finishes and populates items:
    controller.populateFamilles();
    await tester.pump();

    // Rebuild count is now 2!
    expect(rebuildCount, 2);
    expect(find.text('Stocks'), findsOneWidget); // Stocks is now visible!
  });
}
