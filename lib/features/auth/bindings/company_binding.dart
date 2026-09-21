import 'package:softel/controller/auth/company_controller.dart';
import 'package:get/get.dart';

/// Company Feature Binding
/// Handles injection of Company-related controllers
class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    // Using lazyPut ensures the controller is created only when needed
    Get.lazyPut(() => CompanyController());
  }
}
