import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/view/screen/famille/famillespage.dart';
import 'package:softel/view/screen/home/home.dart';
import 'package:softel/view/screen/settings/settings.dart';
import 'package:softel/view/screen/traking/traking.dart';

/// Clean, decoupled HomeScreenController managing bottom navigation tab state.
class HomeScreenController extends GetxController {
  /// Reactive tab index
  final RxInt initialTab = 0.obs;

  /// Pages for each tab
  final List<Widget> listPage = const [
    HomePage(),
    FamillesPage(),
    Traking(),
    Settings(),
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['initialTab'] is int) {
      initialTab.value = args['initialTab'] as int;
    }
  }

  /// Change active tab index cleanly
  void changeTab(int index) {
    initialTab.value = index;
  }
}

