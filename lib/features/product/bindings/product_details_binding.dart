import 'package:softel/controller/product/productdetails_controller.dart';
import 'package:get/get.dart';

/// Product Details Feature Binding
/// Handles injection of Product Details-related controllers
class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetailsController());
  }
}
