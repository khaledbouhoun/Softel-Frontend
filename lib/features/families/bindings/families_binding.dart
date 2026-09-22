import 'package:get/get.dart';
import 'package:softel/controller/familles/famillescontroller.dart';
import 'package:softel/controller/familles/famillesdetailes_controller.dart';
import 'package:softel/controller/familles/soufamillescontroller.dart';

/// Families Feature Binding
///
/// Registers controllers for Families, Sub-Families, and Family Product Details routes.
class FamiliesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamillesController>(() => FamillesController());
    Get.lazyPut<Soufamillescontroller>(() => Soufamillescontroller());
    Get.lazyPut<FamillesdetailesController>(() => FamillesdetailesController());
  }
}
