import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/cart_state_service.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/imagesbanner.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';
import 'package:softel/view/widget/home/category_selector.dart';

class HomeController extends GetxController {
  // ===========================================================================
  // Constants
  // ===========================================================================

  static const int _pageSize = 15;
  static const String _allCategoryId = '00';

  // ===========================================================================
  // Dependencies
  // ===========================================================================

  final MyServices _services = Get.find<MyServices>();
  final Crud _crud = Crud();
  final Dialogfun _dialog = Dialogfun();
  CartStateService get _cartStateService => Get.find<CartStateService>();

  // ===========================================================================
  // Controllers
  // ===========================================================================

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // ===========================================================================
  // Branding
  // ===========================================================================

  final RxnString logoUrl = RxnString();

  // ===========================================================================
  // Cart
  // ===========================================================================

  RxInt get cartCount => _cartStateService.cartCount;

  // ===========================================================================
  // Banners
  // ===========================================================================

  final banners = <ImagesBanner>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // ===========================================================================
  // Categories
  // ===========================================================================

  final familles = <Familles>[].obs;
  final familleItems = <FamilleItem>[].obs;
  final selectedFamille = Rx<Familles>(Familles(famNo: _allCategoryId, famNom: 'all'.tr));
  final RxBool isLoadingFamilies = false.obs;

  // ===========================================================================
  // Products
  // ===========================================================================

  final products = <Product>[].obs;
  final searchResults = <Product>[].obs;

  // ===========================================================================
  // Loading / Pagination
  // ===========================================================================

  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasReachedEnd = false.obs;

  // ===========================================================================
  // Search
  // ===========================================================================

  final RxString searchQuery = ''.obs;

  // ===========================================================================
  // Internal state
  // ===========================================================================

  int _requestId = 0;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _buildFamilleItems();
    _initialize();

    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();

    searchController.dispose();

    super.onClose();
  }

  // ===========================================================================
  // Initialization
  // ===========================================================================

  Future<void> _initialize() async {
    _loadBranding();

    await Future.wait([fetchBanners(), fetchFamilles(), fetchCartCount()]);

    await fetchProducts(reset: true);
  }

  void _loadBranding() {
    logoUrl.value = _services.sharedPreferences.getString('companyImg') ?? AppImageAsset.logo;
  }

  // ===========================================================================
  // Scroll / Pagination
  // ===========================================================================

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;

    const threshold = 300.0;

    final isNearBottom = position.pixels >= position.maxScrollExtent - threshold;

    if (!isNearBottom) return;

    fetchMoreProducts();
  }

  Future<void> fetchMoreProducts() async {
    if (isLoadingProducts.value) return;
    if (isLoadingMore.value) return;
    if (hasReachedEnd.value) return;

    await fetchProducts(reset: false);
  }

  // ===========================================================================
  // Banners
  // ===========================================================================

  Future<void> fetchBanners() async {
    isLoadingBanners.value = true;
    try {
      final response = await _crud.get(AppLink.imagesBanner);

      if (response.statusCode == 404) {
        banners.clear();
        return;
      }

      if (response.statusCode != 200) {
        _showError('Failed to load banners');
        banners.clear();
        return;
      }

      final body = response.body;

      if (body is! List) {
        banners.clear();
        return;
      }

      final parsed = body.whereType<Map<String, dynamic>>().map(ImagesBanner.fromJson).toList();
      banners.assignAll(parsed);
    } catch (e, stackTrace) {
      _logError('fetchBanners', e, stackTrace);
      banners.clear();
    } finally {
      isLoadingBanners.value = false;
    }
  }

  // ===========================================================================
  // Categories
  // ===========================================================================

  Future<void> fetchFamilles() async {
    isLoadingFamilies.value = true;
    try {
      await _fetchFamillesDirectly();
      _buildFamilleItems();
    } catch (e, stackTrace) {
      _logError('fetchFamilles', e, stackTrace);
      familles.clear();
      _buildFamilleItems();
    } finally {
      isLoadingFamilies.value = false;
    }
  }

  Future<void> _fetchFamillesDirectly() async {
    final response = await _crud.get(AppLink.familles);

    if (response.statusCode != 200 || response.body is! List) {
      familles.clear();
      return;
    }

    final parsed = (response.body as List).whereType<Map<String, dynamic>>().map(Familles.fromJson).toList();
    familles.assignAll(parsed);
  }

  void _buildFamilleItems() {
    final allFamille = Familles(famNo: _allCategoryId, famNom: 'all'.tr);

    final items = [FamilleItem(allFamille, AppSvg.widget2Filled), ...familles.map((famille) => FamilleItem(famille, AppSvg.widget2))];
    familleItems.assignAll(items);

    final selectedId = selectedFamille.value.famNo;

    final exists = familleItems.any((item) => item.famille.famNo == selectedId);

    if (!exists) {
      selectedFamille.value = allFamille;
    }
  }

  void selectFamille(Familles famille) {
    if (selectedFamille.value.famNo == famille.famNo) return;

    selectedFamille.value = famille;

    fetchProducts(reset: true);
  }

  void resetSelectedFamille() {
    selectedFamille.value = Familles(famNo: _allCategoryId, famNom: 'all'.tr);
  }

  // Backward compatibility if old views/controllers use this method.
  void reializeSelectedFamille() {
    resetSelectedFamille();
  }

  void goToFamilles(Familles famille) {
    final famNo = int.tryParse(famille.famNo ?? '');

    if (famNo == null || famille.famNom == null) return;

    Get.toNamed(AppRoute.famillesdetailes, arguments: {'catid': famNo, 'catnam': famille.famNom});
  }

  // ===========================================================================
  // Products
  // ===========================================================================

  Future<void> fetchProducts({required bool reset}) async {
    if (reset) {
      if (isLoadingProducts.value) return;

      isLoadingProducts.value = true;
      hasReachedEnd.value = false;

      products.clear();
      searchResults.clear();

      // New request generation.
      _requestId++;
    } else {
      if (isLoadingProducts.value) return;
      if (isLoadingMore.value) return;
      if (hasReachedEnd.value) return;

      isLoadingMore.value = true;
    }

    final currentRequestId = _requestId;
    final offset = reset ? 0 : products.length;

    try {
      final url = _buildProductsUrl(offset);

      final response = await _crud.get(url);

      // Ignore an old request if the user changed category/search/etc.
      if (reset && currentRequestId != _requestId) {
        return;
      }

      if (response.statusCode == 404) {
        if (reset) {
          products.clear();
          searchResults.clear();
        }

        hasReachedEnd.value = true;
        return;
      }

      if (response.statusCode != 200) {
        _showError(reset ? 'Failed to load products' : 'Failed to load more products');
        return;
      }

      final newProducts = _parseProducts(response.body);

      if (reset) {
        products.assignAll(newProducts);
      } else {
        products.addAll(newProducts);
      }

      if (newProducts.length < _pageSize) {
        hasReachedEnd.value = true;
      }

      _updateSearchResults();
    } catch (e, stackTrace) {
      _logError(reset ? 'fetchProducts' : 'fetchMoreProducts', e, stackTrace);
    } finally {
      if (reset) {
        isLoadingProducts.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  String _buildProductsUrl(int offset) {
    final famNo = selectedFamille.value.famNo ?? _allCategoryId;

    return '${AppLink.products}'
        '?offset=$offset'
        '&limit=$_pageSize'
        '&famNo=$famNo';
  }

  List<Product> _parseProducts(dynamic body) {
    if (body is! Map<String, dynamic>) {
      return [];
    }

    final data = body['data'];

    if (data is! List) {
      return [];
    }

    return data.whereType<Map<String, dynamic>>().map(Product.fromJson).toList();
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();

    _updateSearchResults();
  }

  void clearSearch() {
    searchController.clear();

    searchQuery.value = '';

    _updateSearchResults();
  }

  void _updateSearchResults() {
    final q = searchQuery.value;
    if (q.isEmpty) {
      searchResults.assignAll(products);
      return;
    }

    final query = q.toLowerCase();

    final results = products.where((product) {
      final name = product.artNom?.toLowerCase() ?? '';

      return name.contains(query);
    }).toList();

    searchResults.assignAll(results);
  }

  // ===========================================================================
  // Cart
  // ===========================================================================

  Future<void> fetchCartCount() => _cartStateService.fetchCartCount();

  // ===========================================================================
  // Navigation
  // ===========================================================================

  Future<void> goToProductDetails(Product product) async {
    final result = await Get.toNamed(AppRoute.productdetails, arguments: {'product': product, 'fromcart': false});

    if (result == null) {
      return;
    }

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

    await fetchCartCount();
  }

  // Backward compatibility with old code.
  Future<void> goToPageProductDetails(Product product) {
    return goToProductDetails(product);
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  void _showError(String message) {
    _dialog.showSnackError('Error', message);
  }

  void _logError(String method, Object error, StackTrace stackTrace) {
    debugPrint('[HomeController][$method] $error\n$stackTrace');
  }
}
