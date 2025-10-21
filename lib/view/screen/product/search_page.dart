import 'package:softel/core/class/crud.dart';

import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:softel/view/widget/dialog.dart';
import 'package:softel/view/widget/home/product_grid.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      body: GetBuilder<SearchController>(
        init: SearchController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColor.background,
            appBar: AppBar(
              backgroundColor: AppColor.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Backwidget(),
              title: TextField(
                controller: controller.searchController,
                autofocus: true,
                cursorColor: AppColor.primaryColor,
                style: TextStyle(color: AppColor.primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.none,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                onSubmitted: (value) {
                  controller.onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColor.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  fillColor: AppColor.background,
                  filled: true,

                  // prefixIcon: Icon(Icons.search, color: AppColor.primaryColor),
                  suffixIcon: controller.searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColor.primaryColor),
                          onPressed: () {
                            controller.clearSearch();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.onSearchChanged(value);
                  } else {
                    controller.products.clear();
                    controller.update();
                  }
                },
              ),
            ),
            body: GetBuilder<SearchController>(
              builder: (searchcontroller) {
                return searchcontroller.isSearchloading
                    ? Center(child: Loadingwidget(width: 150))
                    : ProductGrid(
                        physics: const AlwaysScrollableScrollPhysics(),
                        products: searchcontroller.products,
                        onTap: (i) {
                          Get.find<HomeController>().goToPageProductDetails(searchcontroller.products[i]);
                        },
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

class SearchController extends GetxController {
  List<Product> products = [];
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  TextEditingController? search;
  bool isSearch = false;
  bool isSearchloading = false;
  TextEditingController searchController = TextEditingController();
  List<Product> favorites = [];

  Future<void> onSearchChanged(String search) async {
    isSearchloading = true;
    products.clear();
    update();

    var response = await crud.get('${AppLink.productssearch}/${search.trim().toLowerCase()}');
    if (response.statusCode == 200) {
      isSearchloading = false;
      products.addAll((response.body as List).map((item) => Product.fromJson(item)).toList());
      update();
    } else if (response.statusCode == 404) {
      isSearchloading = false;
      products = [];
      update();
    } else {
      isSearchloading = false;
      products = [];
      dialogfun.showSnackError("Error", response.body['message']);
    }
    update();
  }

  void clearSearch() {
    searchController.clear();
    products.clear();
    update();
  }

  void toggleFavorite(int index) {
    if (favorites.contains(products[index])) {
      favorites.remove(products[index]);
    } else {
      favorites.add(products[index]);
    }
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
