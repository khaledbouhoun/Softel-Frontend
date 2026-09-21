import 'package:softel/controller/traking/traking_controller.dart';
import 'package:softel/controller/cart/trakingcartdetaills_controller.dart';
import 'package:get/get.dart';

/// Tracking/Orders Feature Binding
/// Handles injection of Tracking and Order Details-related controllers
class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrakingControllerDetails());
  }
}

/// Tracking Details (Order) Feature Binding
class TrackingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrakingcartdetaillsController());
  }
}
