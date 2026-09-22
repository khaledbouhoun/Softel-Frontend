import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/controller/search/search_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class SearchPage extends GetView<SearchsController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Backwidget(),
        title: _SearchTextField(controller: controller),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              // Filter and Sort Bar
              _buildFilterBar(),
              // Search Results
              Expanded(child: _buildResultContent()),
            ],
          ),
        ),
      ),
    );
  }

  /// Build filter and sort bar
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(label: 'sort_relevant'.tr, value: 'relevant', onTap: () => controller.setSortBy('relevant')),
            const SizedBox(width: 8),
            _buildFilterChip(label: 'sort_price_low'.tr, value: 'price_low', onTap: () => controller.setSortBy('price_low')),
            const SizedBox(width: 8),
            _buildFilterChip(label: 'sort_price_high'.tr, value: 'price_high', onTap: () => controller.setSortBy('price_high')),
            const SizedBox(width: 8),
            _buildFilterChip(label: 'sort_newest'.tr, value: 'newest', onTap: () => controller.setSortBy('newest')),
          ],
        ),
      ),
    );
  }

  /// Build content based on current state
  Widget _buildResultContent() {
    if (controller.isLoading.value && controller.products.isEmpty) {
      return _buildLoadingState();
    }
    if (controller.hasError.value && controller.products.isEmpty) {
      return _buildErrorState();
    }
    if (controller.filteredProducts.isEmpty && controller.searchQuery.value.isNotEmpty) {
      return _buildEmptyState();
    }
    return _buildResultsView();
  }

  /// Build individual filter chip
  Widget _buildFilterChip({required String label, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: controller.sortBy.value == value ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.sortBy.value == value ? AppColor.primaryColor : AppColor.grey,
            width: controller.sortBy.value == value ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: controller.sortBy.value == value ? Colors.white : AppColor.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Loadingwidget(width: 100),
          const SizedBox(height: 16),
          Text(
            'searching_products'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColor.grey),
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: AppColor.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColor.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retrySearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'retry'.tr,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🌫 Icon container (soft + premium)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: AppColor.primaryColor.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(Icons.search_off_rounded, size: 48, color: AppColor.primaryColor.withValues(alpha: 0.6)),
            ),

            const SizedBox(height: 28),

            /// 🧠 Title (stronger hierarchy)
            Text(
              'no_products_found'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.2),
            ),

            const SizedBox(height: 10),

            /// ✨ Subtitle (softer tone)
            Text(
              'try_different_search'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.grey.withValues(alpha: 0.7), height: 1.5),
            ),

            const SizedBox(height: 28),

            /// 🔹 Optional CTA (very pro touch)
            GestureDetector(
              onTap: () {
                // e.g. clear search / reload
                controller.clearSearch();
                controller.onSearchChanged(controller.searchQuery.value);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.primaryColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  "Reset search",
                  style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build results view with pagination
  Widget _buildResultsView() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!controller.isLoadingMore.value &&
            controller.hasMoreResults.value &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.onSearchChanged(controller.searchQuery.value);
        }
        return false;
      },
      child: Column(
        children: [
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'found'.tr}: ${controller.filteredProducts.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.grey),
                ),
                if (!controller.hasMoreResults.value)
                  Text(
                    'no_more_products'.tr,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColor.grey.withValues(alpha: 0.6)),
                  ),
              ],
            ),
          ),
          // Products grid
          Expanded(
            child: ProductGrid(
              physics: const AlwaysScrollableScrollPhysics(),
              products: controller.filteredProducts.toList(),
              isLoadingProducts: controller.isLoading.value,
              scrollercontroller: controller.scrollController,
              enableScroll: true,
              onTap: (index) {
                if (index < controller.filteredProducts.length) {
                  Get.toNamed(
                    AppRoute.productdetails,
                    arguments: {
                      'product': controller.filteredProducts[index],
                      'fromcart': false,
                    },
                  );
                }
              },
            ),
          ),
          // Loading more indicator
          if (controller.isLoadingMore.value) const Padding(padding: EdgeInsets.all(16), child: Loadingwidget(width: 50)),
        ],
      ),
    );
  }
}

/// Search TextField Widget
class _SearchTextField extends StatefulWidget {
  final SearchsController controller;

  const _SearchTextField({required this.controller});

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColor.grey.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: widget.controller.searchController,
        autofocus: true,
        cursorColor: AppColor.primaryColor,
        style: TextStyle(color: AppColor.primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'search_products'.tr,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintStyle: TextStyle(color: AppColor.grey.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w500),
          prefixIcon: Icon(Icons.search, color: AppColor.primaryColor, size: 20),
          suffixIcon: widget.controller.searchController.text.trim().isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColor.primaryColor, size: 20),
                  onPressed: widget.controller.clearSearch,
                )
              : null,
        ),
        onChanged: widget.controller.onSearchChanged,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.searchController.removeListener(_onTextChanged);
    super.dispose();
  }
}
