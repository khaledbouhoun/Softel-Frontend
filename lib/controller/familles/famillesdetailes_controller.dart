import 'package:softel/core/class/crud.dart';

import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/data/model/soufamilles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/screen/product/productdetails.dart';
import 'package:softel/view/widget/dialog.dart';

class FamillesdetailesController extends GetxController {
  MyServices myServices = Get.find();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();

  List<Product> products = [];
  List<Product> filteredProducts = [];
  int offset = 0;
  bool isoffsetloding = false;
  RxBool endofproducts = false.obs;
  String? message = "No more products";
  final ScrollController scrollController = ScrollController();
  TextEditingController? search;
  Familles? famille;
  SouFamilles? souFamille;

  @override
  void onInit() {
    famille = Get.arguments['famille'];
    souFamille = Get.arguments['soufamille'];
    fetch();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        isoffsetloding = true;
        fetch();
        isoffsetloding = false;
      }
    });

    search = TextEditingController();
    super.onInit();
  }

  Future<void> fetch({bool isoffsetloding = false}) async {
    var response = await crud.post(AppLink.parfamilles, {
      'offset': products.length,
      'limit': 15,
      'ArtFam': famille?.famNo,
      'ArtSFam': souFamille?.souNo,
    });
    if (response.statusCode == 201) {
      products.addAll((response.body as List).map((item) => Product.fromJson(item)).toList());
      filteredProducts = List.from(products);
    } else if (response.statusCode == 404 && products.isNotEmpty) {
      endofproducts.value = true;
    } else if (response.statusCode == 404 && products.isEmpty) {
      products = [];
    } else {
      products = [];
      dialogfun.showSnackError("Error", "Failed to load products");
    }
    update();
  }

  Future<void> goToPageProductDetails(Product product) async {
    final double? result = await Get.to<double?>(() => ProductDetails(), arguments: {"product": product, "fromcart": false});
    if (result != null) {
      product.artQte = result;
      update();
    }
  }

  searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products.where((item) => (item.artNom ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    }
    update();
  }
}
