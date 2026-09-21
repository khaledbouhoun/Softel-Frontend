import 'package:get/get.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/controller/home/homescreen_controller.dart';

/// Home Feature Binding
///
/// Only controllers required for the home route
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(
      () => HomeScreenController(),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
