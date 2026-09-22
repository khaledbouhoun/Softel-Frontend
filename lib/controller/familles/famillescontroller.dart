import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class FamillesController extends GetxController {
  final MyServices _myServices = Get.find<MyServices>();
  final Crud _crud = Crud();
  final Dialogfun _dialogfun = Dialogfun();
  final TextEditingController searchController = TextEditingController();

  final familles = <Familles>[].obs;
  final filteredfamilles = <Familles>[].obs;
  final RxString logoUrl = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    logoUrl.value = _myServices.sharedPreferences.getString("companyImg") ?? "";
    fetch();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final response = await _crud.get(AppLink.familles);
      if (response.statusCode == 200 && response.body is List) {
        final items = (response.body as List)
            .whereType<Map<String, dynamic>>()
            .map(Familles.fromJson)
            .toList();
        familles.assignAll(items);
        filteredfamilles.assignAll(items);
      } else if (response.statusCode == 404) {
        familles.clear();
        filteredfamilles.clear();
      } else {
        familles.clear();
        filteredfamilles.clear();
        _dialogfun.showSnackError("Error ${response.statusCode}", response.body?['message']?.toString() ?? '');
      }
    } catch (e) {
      familles.clear();
      filteredfamilles.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredfamilles.assignAll(familles);
    } else {
      final lower = query.toLowerCase();
      filteredfamilles.assignAll(
        familles.where((item) => (item.famNom ?? '').toLowerCase().contains(lower)).toList(),
      );
    }
  }

  void goToCategoreis(Familles familles) {
    Get.toNamed(AppRoute.soufamilles, arguments: {"famille": familles});
  }
}

