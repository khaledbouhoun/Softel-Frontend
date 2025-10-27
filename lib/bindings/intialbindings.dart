import 'package:softel/controller/auth/company_controller.dart';
import 'package:softel/controller/auth/login_controller.dart';
import 'package:softel/core/class/crud.dart';
import 'package:get/get.dart';
import 'package:softel/core/constant/color.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Start
    Get.put(Crud());
    Get.put(AppColor());
    Get.put(CompanyController());
    // Get.put(LoginController());
    // Get.put(HomeController());
  }
}
