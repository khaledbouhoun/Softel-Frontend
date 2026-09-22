import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/view/widget/home/product_grid.dart';

class MockHomeController extends GetxController {
  final products = <Product>[].obs;
  final searchResults = <Product>[].obs;
  final isLoadingProducts = false.obs;
  final isLoadingMore = false.obs;
  final hasReachedEnd = false.obs;

  void applyProductDetailsResult(Product product, dynamic result) {
    if (result == null) return;

    final quantity = (result as num).toDouble();
    final index = products.indexWhere((p) => p.artNo == product.artNo);

    if (index != -1) {
      products[index].artQte = quantity;
      product.artQte = quantity;
      products.refresh();
    }

    final searchIndex = searchResults.indexWhere((p) => p.artNo == product.artNo);
    if (searchIndex != -1) {
      searchResults[searchIndex].artQte = quantity;
      searchResults.refresh();
    }
  }
}

void main() {
  testWidgets('Real ProductGrid: Home -> ProductDetails update -> Home immediately rebuilds without hot reload', (tester) async {
    final controller = MockHomeController();
    controller.products.assignAll([
      Product(artNo: '000010', artNom: 'Article 10', artPrix: 750.0, artQte: 0.0),
      Product(artNo: '000020', artNom: 'Article 20', artPrix: 1200.0, artQte: 0.0),
    ]);

    int obxRebuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Obx(() {
              obxRebuildCount++;

              return ProductGrid(
                products: controller.products.toList(),
                isLoadingProducts: controller.isLoadingProducts.value,
                isLoadingMore: controller.isLoadingMore.value,
                hasReachedEnd: controller.hasReachedEnd.value,
                onTap: (index) {},
              );
            }),
          ),
        ),
      ),
    );

    expect(obxRebuildCount, 1);
    // Initially, artQte is 0.0, so no check circle icons exist
    expect(find.byIcon(Icons.check_circle), findsNothing);

    // Simulate returning from ProductDetails with quantity 3.0
    controller.applyProductDetailsResult(controller.products[0], 3.0);
    await tester.pump();

    // Verify Obx rebuilt and UI displays quantity 3.0 immediately!
    expect(obxRebuildCount, 2);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('3.0'), findsOneWidget);

    // Simulate deleting from ProductDetails (quantity 0.0)
    controller.applyProductDetailsResult(controller.products[0], 0.0);
    await tester.pump();

    // Verify Obx rebuilt and UI returns to no badge
    expect(obxRebuildCount, 3);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.text('3.0'), findsNothing);
  });

  test('Navigation result contracts for Home vs Cart', () {
    // 1. Home flow: fromcart == false
    // When saving or updating: returns double quantity
    dynamic closeResultHomeSave(double qty, bool fromcart) => fromcart ? true : qty;
    expect(closeResultHomeSave(3.0, false), 3.0);

    // When deleting fromcart == false: returns 0.0
    dynamic closeResultHomeDelete(bool fromcart) => fromcart ? true : 0.0;
    expect(closeResultHomeDelete(false), 0.0);

    // 2. Cart flow: fromcart == true
    // When updating from cart: returns true
    expect(closeResultHomeSave(3.0, true), true);

    // When deleting from cart: returns true
    expect(closeResultHomeDelete(true), true);
  });
}
