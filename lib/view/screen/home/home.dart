import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/view/widget/home/category_selector.dart';
import 'package:softel/view/widget/home/customcardhome.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:softel/view/widget/home/top_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.primaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 2,
          onRefresh: _refresh,
          child: ListView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [_buildTopBar(), _buildBanners(), _buildSearch(), _buildCategories(), _buildProducts(), const SizedBox(height: 30)],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Refresh
  // ===========================================================================

  Future<void> _refresh() async {
    controller.resetSelectedFamille();

    await Future.wait([controller.fetchBanners(), controller.fetchFamilles(), controller.fetchCartCount()]);

    await controller.fetchProducts(reset: true);
  }

  // ===========================================================================
  // Top Bar
  // ===========================================================================

  Widget _buildTopBar() {
    return Obx(() => TopBar(logoUrl: controller.logoUrl.value, cartCount: controller.cartCount.value));
  }

  // ===========================================================================
  // Banners
  // ===========================================================================

  Widget _buildBanners() {
    return Obx(() => CustomCardHome(images: controller.banners.toList(), isLoading: controller.isLoadingBanners.value));
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  Widget _buildSearch() {
    return GestureDetector(
      onTap: _openSearchPage,
      child: AbsorbPointer(
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColor.primaryColor, width: 1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(AppSvg.search, colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn), width: 22, height: 22),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'serch_product'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColor.grey, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),

              const SizedBox(width: 8),

              _buildQuickSearchBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSearchBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: AppColor.primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppSvg.search, colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn), width: 15, height: 15),

          const SizedBox(width: 4),

          Text(
            'quick_search'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _openSearchPage() {
    Get.toNamed(AppRoute.search);
  }

  // ===========================================================================
  // Categories
  // ===========================================================================

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        _buildSectionTitle('familles'.tr),

        Obx(
          () => FamilleSelector(
            famillesItems: controller.familleItems.toList(),
            selectedFamille: controller.selectedFamille.value,
            onSelectFamille: controller.selectFamille,
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // ===========================================================================
  // Products
  // ===========================================================================

  Widget _buildProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('products'.tr),

        const SizedBox(height: 10),

        Obx(() {
          return ProductGrid(
            products: controller.products.toList(),
            isLoadingProducts: controller.isLoadingProducts.value,
            isLoadingMore: controller.isLoadingMore.value,
            hasReachedEnd: controller.hasReachedEnd.value,
            onTap: (index) {
              if (index < 0 || index >= controller.products.length) {
                return;
              }

              controller.goToProductDetails(controller.products[index]);
            },
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // Section Title
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
