import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/cart_state_service.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/data/model/soufamilles.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class FamillesdetailesController extends GetxController {
  // ---------------------------------------------------------------------------
  // Dependencies
  // ---------------------------------------------------------------------------

  final MyServices myServices = Get.find<MyServices>();
  final CartStateService cartStateService = Get.find<CartStateService>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  // ---------------------------------------------------------------------------
  // Models / Category State
  // ---------------------------------------------------------------------------

  Familles? famille;
  SouFamilles? souFamille;

  // ---------------------------------------------------------------------------
  // Products State
  // ---------------------------------------------------------------------------

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final RxBool isloadingProducts = false.obs;
  final RxBool isloadingMore = false.obs;
  final RxBool endofproducts = false.obs;
  final String message = "No more products";

  // ---------------------------------------------------------------------------
  // Controllers
  // ---------------------------------------------------------------------------

  final ScrollController scrollController = ScrollController();
  final TextEditingController search = TextEditingController();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    search.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  void _initializeData() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['famille'] is Familles) {
        famille = args['famille'] as Familles;
      } else if (args['catid'] != null) {
        famille = Familles(famNo: args['catid'].toString(), famNom: args['catnam']?.toString());
      }
      if (args['soufamille'] is SouFamilles) {
        souFamille = args['soufamille'] as SouFamilles;
      }
    }

    scrollController.addListener(_onScroll);
    fetch(reset: true);
  }

  // ---------------------------------------------------------------------------
  // Scroll / Pagination
  // ---------------------------------------------------------------------------

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isloadingProducts.value && !isloadingMore.value && !endofproducts.value) {
        fetch(reset: false);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch Products
  // ---------------------------------------------------------------------------

  Future<void> fetch({bool reset = false}) async {
    if (reset) {
      if (isloadingProducts.value) return;
      isloadingProducts.value = true;
      endofproducts.value = false;
      products.clear();
      filteredProducts.clear();
    } else {
      if (isloadingMore.value || endofproducts.value) return;
      isloadingMore.value = true;
    }

    try {
      final famNo = famille?.famNo ?? '';
      final souNo = souFamille?.souNo ?? '';
      final offset = reset ? 0 : products.length;

      final response = await crud.get("${AppLink.parfamilles}?offset=$offset&limit=15&ArtFam=$famNo&ArtSFam=$souNo");

      if (response.statusCode == 200 && response.body is List) {
        final newProducts = (response.body as List).whereType<Map<String, dynamic>>().map(Product.fromJson).toList();

        if (reset) {
          products.assignAll(newProducts);
        } else {
          products.addAll(newProducts);
        }

        if (newProducts.length < 15) {
          endofproducts.value = true;
        }
        _applySearch();
      } else if (response.statusCode == 404) {
        endofproducts.value = true;
        if (reset) {
          products.clear();
          filteredProducts.clear();
        }
      } else {
        if (reset) {
          products.clear();
          filteredProducts.clear();
        }
        dialogfun.showSnackError("Error", "Failed to load products");
      }
    } catch (e) {
      if (reset) {
        products.clear();
        filteredProducts.clear();
      }
    } finally {
      if (reset) {
        isloadingProducts.value = false;
      } else {
        isloadingMore.value = false;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  void searchProducts(String query) {
    _applySearch();
  }

  void _applySearch() {
    final query = search.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(products.where((item) => (item.artNom ?? '').toLowerCase().contains(query)).toList());
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  Future<void> goToPageProductDetails(Product product) async {
    final result = await Get.toNamed(AppRoute.productdetails, arguments: {"product": product, "fromcart": false});

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

    _applySearch();

    await cartStateService.fetchCartCount();
  }
}
