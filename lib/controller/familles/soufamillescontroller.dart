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
  MyServices myServices = Get.find();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  List<SouFamilles> soufamilles = [];
  List<SouFamilles> soufilteredfamilles = [];
  SouFamilles selectedsoufamille = SouFamilles();
  Familles selectedfamille = Familles();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    selectedfamille = Get.arguments['famille'];
    fetch();
    super.onInit();
  }

  Future<void> fetch() async {
    var response = await crud.get("${AppLink.familles}/${selectedfamille.famNo}");
    if (response.statusCode == 200) {
      soufamilles = (response.body as List).map((item) => SouFamilles.fromJson(item)).toList();
      soufilteredfamilles = List.from(soufamilles);
    } else if (response.statusCode == 404) {
      soufamilles = [];
    } else {
      soufamilles = [];
      dialogfun.showSnackError("Error ${response.statusCode}", response.body['message']);
    }
    update();
  }

  void soufamillesProducts(SouFamilles soufamilles) {
    Get.toNamed(AppRoute.famillesdetailes, arguments: {"famille": selectedfamille, "soufamille": soufamilles});
  }
  searchProducts(String query) {
    if (query.isEmpty) {
      soufilteredfamilles = List.from(soufamilles);
    } else {
      soufilteredfamilles = soufamilles.where((item) => (item.souNom ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    }
    update();
  }
}
