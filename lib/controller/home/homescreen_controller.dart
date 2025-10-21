import 'package:softel/view/screen/famille/famillespage.dart';
import 'package:softel/view/screen/home/home.dart';
import 'package:softel/view/screen/settings/settings.dart';
import 'package:softel/view/screen/traking/traking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  late int initialTab;

  List<Widget> listPage = [const HomePage(), FamillesPage(), Traking(), const Settings()];

  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments?['initialTab'] ?? 0;
  }
}
