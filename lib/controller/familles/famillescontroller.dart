import 'package:flutter/material.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:get/get.dart';
import 'package:softel/data/model/familles.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class FamillesController extends GetxController {
  MyServices myServices = Get.find();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  TextEditingController searchController = TextEditingController();
  List<Familles> familles = [];
  List<Familles> filteredfamilles = [];
  String logoUrl = "";

  @override
  void onInit() {
    logoUrl = myServices.sharedPreferences.getString("companyImg") ?? "";
    fetch();
    super.onInit();
  }

  Future<void> fetch() async {
    var response = await crud.get(AppLink.familles);
    if (response.statusCode == 200) {
      familles = (response.body as List).map((item) => Familles.fromJson(item)).toList();
      filteredfamilles = List.from(familles);
    } else if (response.statusCode == 404) {
      familles = [];
    } else {
      familles = [];
      dialogfun.showSnackError("Error ${response.statusCode}", response.body['message']);
    }
    update();
  }

  searchProducts(String query) {
    if (query.isEmpty) {
      filteredfamilles = List.from(familles);
    } else {
      filteredfamilles = familles.where((item) => (item.famNom ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    }
    update();
  }

  void goToCategoreis(Familles familles) {
    Get.toNamed(AppRoute.soufamilles, arguments: {"famille": familles});
  }
}
