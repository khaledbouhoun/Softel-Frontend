import 'package:softel/controller/auth/login_controller.dart';
import 'package:get/get.dart';

/// Login Feature Binding
/// Handles injection of Login-related controllers
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
