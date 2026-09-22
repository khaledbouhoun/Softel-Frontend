import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/services/cart_state_service.dart';

/// Initial Bindings Layer
///
/// Global services and singleton instances needed throughout the app lifetime.
class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // Core utilities - permanent services
    Get.put(Crud(), permanent: true);
    Get.put(AppColor(), permanent: true);
    Get.put(CartStateService(), permanent: true);
  }
}
