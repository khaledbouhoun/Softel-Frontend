import 'dart:async';
import 'package:softel/core/class/crud.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/dialog.dart';

class SearchsController extends GetxController {
  // Dependencies
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  // State variables
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'relevant'.obs; // relevant, price_low, price_high, newest
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // TextField controller
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Debounce timer
  Timer? _debounceTimer;
  static const int _debounceMilliseconds = 600;

  // Pagination
  int _currentPage = 0;
  static const int _pageSize = 20;
  final RxBool hasMoreResults = true.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  /// Handle infinite scroll pagination
  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (hasMoreResults.value && !isLoadingMore.value && searchQuery.value.isNotEmpty) {
        _loadMoreResults();
      }
    }
  }

  /// Load more results for pagination
  Future<void> _loadMoreResults() async {
    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      _currentPage++;

      final query = searchQuery.value.trim();
      final response = await crud.get('${AppLink.productssearch}/$query?page=$_currentPage&limit=$_pageSize');

      if (response.statusCode == 200) {
        _parseAndAddProducts(response.body);
      } else if (response.statusCode == 404) {
        hasMoreResults.value = false;
      } else {
        _handleError(response.body);
      }
    } catch (e) {
      debugPrint('Error loading more results: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Handle search query changes with debounce
  void onSearchChanged(String value) {
    final query = value.trim();
    searchQuery.value = query;
    hasError.value = false;

    // Clear existing timer
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      products.clear();
      filteredProducts.clear();
      hasMoreResults.value = true;
      _currentPage = 0;
      return;
    }

    // Show loading state
    isLoading.value = true;

    // Set new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: _debounceMilliseconds), () => _performSearch(query));
  }

  /// Perform the actual API search
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      products.clear();
      filteredProducts.clear();
      _currentPage = 0;
      hasMoreResults.value = true;

      final response = await crud.get('${AppLink.productssearch}/$query?page=0&limit=$_pageSize');

      if (response.statusCode == 200) {
        _parseAndAddProducts(response.body);

        if (products.isEmpty) {
          hasError.value = true;
          errorMessage.value = 'no_products_found'.tr;
        }
      } else if (response.statusCode == 404) {
        errorMessage.value = 'no_products_found'.tr;
        products.clear();
      } else {
        _handleError(response.body);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'search_error_occurred'.tr;
      debugPrint('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse products from API response and add to list
  void _parseAndAddProducts(dynamic responseBody) {
    try {
      List<Product> newProducts = [];

      if (responseBody is List) {
        newProducts = (responseBody).map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
      } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
        final dataList = responseBody['data'];
        if (dataList is List) {
          newProducts = (dataList).map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
        }
      }

      if (newProducts.isEmpty) {
        hasMoreResults.value = false;
      } else if (newProducts.length < _pageSize) {
        hasMoreResults.value = false;
      }

      products.addAll(newProducts);

      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('Error parsing products: $e');
      hasError.value = true;
      errorMessage.value = 'error_parsing_data'.tr;
    }
  }

  /// Extract error message from API response
  String _extractErrorMessage(dynamic responseBody) {
    if (responseBody is Map<String, dynamic>) {
      final message = responseBody['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return 'something_went_wrong'.tr;
  }

  /// Handle API errors
  void _handleError(dynamic responseBody) {
    hasError.value = true;
    errorMessage.value = _extractErrorMessage(responseBody);
    debugPrint('API Error: $errorMessage');
  }

  /// Sort products based on selected sort option
  void setSortBy(String sort) {
    sortBy.value = sort;
    _applyFiltersAndSort();
  }

  /// Apply filters and sorting
  void _applyFiltersAndSort() {
    List<Product> sorted = List.from(products);

    // Apply sorting
    switch (sortBy.value) {
      case 'price_low':
        sorted.sort((a, b) => (a.artPrix ?? 0).compareTo(b.artPrix ?? 0));
        break;
      case 'price_high':
        sorted.sort((a, b) => (b.artPrix ?? 0).compareTo(a.artPrix ?? 0));
        break;
      case 'newest':
        // Assuming newer items come first in API response
        sorted = sorted.reversed.toList();
        break;
      case 'relevant':
      default:
        // Keep original order from API
        break;
    }

    filteredProducts.assignAll(sorted);
  }

  /// Clear search and reset state
  void clearSearch() {
    _debounceTimer?.cancel();
    searchController.clear();
    products.clear();
    filteredProducts.clear();
    searchQuery.value = '';
    sortBy.value = 'relevant';
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    _currentPage = 0;
    hasMoreResults.value = true;
  }

  /// Retry search after error
  void retrySearch() {
    if (searchQuery.value.isNotEmpty) {
      _performSearch(searchQuery.value);
    }
  }

  /// Properly dispose resources
  void disposeSearch() {
    _debounceTimer?.cancel();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
