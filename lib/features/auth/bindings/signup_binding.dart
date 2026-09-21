import 'package:softel/controller/auth/signup_controller.dart';
import 'package:get/get.dart';

/// Sign Up Feature Binding
/// Handles injection of SignUp-related controllers
class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
