import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/imagesbanner.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/screen/product/productdetails.dart';
import 'package:softel/view/widget/dialog.dart';
import 'package:softel/view/widget/home/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // --- My Services ---
  MyServices myServices = Get.find();
  Dialogfun dialogfun = Dialogfun();
  Crud crud = Crud();

  String logoUrl = "";

  RxInt cartcount = 0.obs;
  // --- familles ---
  List<Familles> familles = [];
  Familles famillesselcted = Familles();

  // --- products ---
  RxBool isloadingProducts = false.obs;
  List<Product> products = [];
  List<Product> productssearch = [];
  List<Product> filteredproductsbyfamille = [];
  List<FamilleItem> familleproducts = [];
  // --- Offset ---
  bool isoffsetloding = false;
  final ScrollController scrollController = ScrollController();
  RxBool endofproducts = false.obs;
  // --- Cart ---
  String idcart = "";
  // --- Status Request ---
  // --- Search ---
  TextEditingController? search = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  // --- Selected famille ---
  int selectedfamille = 0;

  // --- Images ---
  List<ImagesBanner> bannerImage = [];
  // --- Favorites ---
  List<bool> favorites = [];

  @override
  void onInit() {
    print("Home Controller Initialized");
    print("img $logoUrl");
    logoUrl = myServices.sharedPreferences.getString("companyImg") ?? AppImageAsset.logo;
    print("img $logoUrl");
    fetchbanner();
    fetchFamilles();
    fetch();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetch(isoffsetloding: true);
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  ///  ----banner ----

  Future<void> fetchbanner() async {
    var response = await crud.get(AppLink.imagesBanner);
    if (response.statusCode == 200) {
      bannerImage.addAll((response.body as List).map((item) => ImagesBanner.fromJson(item)).toList());
    } else if (response.statusCode == 404) {
      bannerImage = [];
    } else {
      dialogfun.showSnackError("Error", "Failed to load banner images");
    }
    update();
  }

  Future<void> countcart() async {
    var response = await crud.get(AppLink.cartCount);
    if (response.statusCode == 200) {
      cartcount.value = response.body['cartCount'] ?? 0;
    } else {
      cartcount.value = 0;
    }
    update();
  }

  // ---fAMILLES ----
  void regeneratefamilleproducts() {
    familleproducts = [
      FamilleItem('all'.tr, AppSvg.widget2Filled),
      ...familles.map((fam) => FamilleItem(fam.famNom ?? '', AppSvg.widget2)),
    ];
  }

  Future<void> fetchFamilles() async {
    FamillesController famillesController = Get.put(FamillesController());

    await famillesController.fetch();
    familles = famillesController.familles;
    update();
    regeneratefamilleproducts();
  }

  List<Product> getFilteredproducts() {
    if (selectedfamille == 0) {
      return products;
    } else if (familles.isNotEmpty && selectedfamille - 1 < familles.length) {
      return products.where((item) => item.artFam == familles[selectedfamille - 1].famNom).toList();
    } else {
      return [];
    }
  }

  void goToFamilles(Familles familles) {
    Get.toNamed(AppRoute.famillesdetailes, arguments: {"catid": int.parse(familles.famNo!), "catnam": familles.famNom!});
  }

  // PRODUCT ---

  Future<void> fetchAll() async {
    products.clear();
    endofproducts.value = false;
    await fetch();
  }

  Future<void> fetch({bool isoffsetloding = false}) async {
    isloadingProducts.value = true;
    var response = await crud.post(AppLink.products, {
      'offset': products.length,
      'limit': 15,
      'famNo': (selectedfamille - 1) >= 0 ? familles[selectedfamille - 1].famNo : "00",
    });
    if (response.statusCode == 201) {
      isloadingProducts.value = false;
      products.addAll((response.body['data'] as List).map((item) => Product.fromJson(item)).toList());
      countcart();
      filteredproductsbyfamille = getFilteredproducts();
    } else if (response.statusCode == 404 && products.isNotEmpty) {
      isloadingProducts.value = false;
      endofproducts.value = true;
    } else if (response.statusCode == 404 && products.isEmpty) {
      isloadingProducts.value = false;
      products = [];
    } else {
      isloadingProducts.value = false;
      products = [];
      dialogfun.showSnackError("Error", "Failed to load products");
    }
    update();
  }

  Future<void> goToPageProductDetails(Product product) async {
    final double? result = await Get.to<double?>(() => ProductDetails(), arguments: {"product": product, "fromcart": false});
    if (result != null) {
      product.artQte = result;
      countcart();
      update();
    }
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    filterproducts();
    update();
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  void filterproducts() {
    if (searchQuery.isEmpty) {
      productssearch = products; // or whatever your full list is called
    } else {
      productssearch = products.where((item) => (item.artNom ?? '').toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    update();
  }
}
