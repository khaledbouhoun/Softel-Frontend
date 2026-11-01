import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/view/widget/loading/banner_shimmer.dart';
import 'package:softel/view/widget/loading/bottom_load_more_indicator.dart';
import 'package:softel/view/widget/loading/category_shimmer.dart';
import 'package:softel/view/widget/loading/product_card_shimmer.dart';
import 'package:softel/view/widget/loading/product_grid_shimmer.dart';
import 'package:softel/view/widget/loading/shimmer_base.dart';
import 'package:softel/view/widget/loading/shimmer_box.dart';
import 'package:softel/view/widget/home/product_grid.dart';

void main() {
  group('Shimmer Foundation & Skeletons', () {
    testWidgets('ShimmerBase adapts colors in Light and Dark mode', (tester) async {
      // Light Mode test
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ShimmerBase(child: Text('Loading...')),
          ),
        ),
      );

      final shimmerLight = tester.widget<Shimmer>(find.byType(Shimmer));
      expect(shimmerLight.gradient, isNotNull);

      // Dark Mode test
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: ShimmerBase(child: Text('Loading...')),
          ),
        ),
      );

      final shimmerDark = tester.widget<Shimmer>(find.byType(Shimmer));
      expect(shimmerDark.gradient, isNotNull);
    });

    testWidgets('ShimmerBox renders with correct dimensions and radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(width: 100, height: 50, borderRadius: 12),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.tighten(width: 100, height: 50), isNotNull);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('BannerShimmer renders with matching banner height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerShimmer(height: 160),
          ),
        ),
      );

      expect(find.byType(BannerShimmer), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('CategoryShimmer renders 5 category pills by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryShimmer(),
          ),
        ),
      );

      expect(find.byType(CategoryShimmer), findsOneWidget);
      expect(find.byType(ShimmerBox), findsNWidgets(5));
    });

    testWidgets('ProductGridShimmer renders with correct grid configuration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductGridShimmer(),
          ),
        ),
      );

      expect(find.byType(ProductGridShimmer), findsOneWidget);
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.childrenDelegate as SliverChildBuilderDelegate;
      expect(delegate.childCount, 6);
      expect(find.byType(ProductCardShimmer), findsWidgets);
    });

    testWidgets('BottomLoadMoreIndicator renders compact circular progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomLoadMoreIndicator(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 24.0);
      expect(sizedBox.height, 24.0);
    });
  });

  group('ProductGrid Loading States', () {
    testWidgets('ProductGrid displays ProductGridShimmer when empty and loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductGrid(
              products: const [],
              isLoadingProducts: true,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ProductGridShimmer), findsOneWidget);
      expect(find.byType(ProductCardShimmer), findsWidgets);
    });

    testWidgets('ProductGrid displays products and BottomLoadMoreIndicator when isLoadingMore', (tester) async {
      final sampleProducts = [
        Product(artNo: '1', artNom: 'Item 1', artPrix: 100, artQte: 0),
        Product(artNo: '2', artNom: 'Item 2', artPrix: 200, artQte: 0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductGrid(
                products: sampleProducts,
                isLoadingProducts: false,
                isLoadingMore: true,
                onTap: (_) {},
              ),
            ),
          ),
        ),
      );

      // Existing products stay visible
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      // Bottom loader appears
      expect(find.byType(BottomLoadMoreIndicator), findsOneWidget);
    });
  });
}
