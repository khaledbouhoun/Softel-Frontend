import 'package:softel/controller/search/search_controller.dart';
import 'package:get/get.dart';

/// Search Feature Binding
/// Handles injection of Search-related controllers
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchsController());
  }
}
