import 'package:get/get.dart';
import 'package:softel/controller/cart/trakingcartdetaills_controller.dart';
import 'package:softel/controller/traking/traking_controller.dart';

/// Tracking/Orders Feature Binding
class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrakingController>(() => TrakingController());
    Get.lazyPut<TrakingControllerDetails>(() => TrakingControllerDetails());
  }
}

/// Tracking Cart Details (Order Items) Feature Binding
class TrackingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrakingcartdetaillsController>(() => TrakingcartdetaillsController());
  }
}
