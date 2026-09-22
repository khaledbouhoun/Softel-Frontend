import 'package:flutter/material.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:get/get.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/data/model/soufamilles.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class Soufamillescontroller extends GetxController {
  final MyServices myServices = Get.find<MyServices>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();
  final TextEditingController searchController = TextEditingController();

  final soufamilles = <SouFamilles>[].obs;
  final soufilteredfamilles = <SouFamilles>[].obs;
  final Rx<SouFamilles> selectedsoufamille = SouFamilles().obs;
  final Rx<Familles> selectedfamille = Familles().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['famille'] is Familles) {
      selectedfamille.value = args['famille'] as Familles;
    }
    fetch();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetch() async {
    final famNo = selectedfamille.value.famNo;
    if (famNo == null || famNo.isEmpty) {
      soufamilles.clear();
      soufilteredfamilles.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await crud.get("${AppLink.familles}/$famNo");
      if (response.statusCode == 200 && response.body is List) {
        final items = (response.body as List)
            .whereType<Map<String, dynamic>>()
            .map(SouFamilles.fromJson)
            .toList();
        soufamilles.assignAll(items);
        soufilteredfamilles.assignAll(items);
      } else if (response.statusCode == 404) {
        soufamilles.clear();
        soufilteredfamilles.clear();
      } else {
        soufamilles.clear();
        soufilteredfamilles.clear();
        dialogfun.showSnackError("Error ${response.statusCode}", response.body?['message']?.toString() ?? '');
      }
    } catch (e) {
      soufamilles.clear();
      soufilteredfamilles.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void soufamillesProducts(SouFamilles soufamilles) {
    Get.toNamed(AppRoute.famillesdetailes, arguments: {"famille": selectedfamille.value, "soufamille": soufamilles});
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      soufilteredfamilles.assignAll(soufamilles);
    } else {
      final lower = query.toLowerCase();
      soufilteredfamilles.assignAll(
        soufamilles.where((item) => (item.souNom ?? '').toLowerCase().contains(lower)).toList(),
      );
    }
  }
}

