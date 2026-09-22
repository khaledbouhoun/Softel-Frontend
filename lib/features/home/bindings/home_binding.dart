import 'package:get/get.dart';
import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/controller/home/homescreen_controller.dart';
import 'package:softel/controller/settings/settings_controller.dart';
import 'package:softel/controller/traking/traking_controller.dart';

/// Home Feature Binding
///
/// Registers controllers required by HomeScreen and its four embedded tabs:
/// Home, Families, Orders (Tracking), and Settings.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FamillesController>(() => FamillesController());
    Get.lazyPut<TrakingController>(() => TrakingController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
