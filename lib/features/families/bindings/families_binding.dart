import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:get/get.dart';

/// Families/Categories Feature Binding
/// Handles injection of Families-related controllers
class FamiliesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FamillesController());
  }
}
