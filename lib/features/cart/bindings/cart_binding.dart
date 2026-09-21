import 'package:softel/controller/cart/cart_controller.dart';
import 'package:get/get.dart';

/// Cart Feature Binding
/// Handles injection of Cart-related controllers
class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController());
  }
}
