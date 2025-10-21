import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/data/model/company.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class CompanyController extends GetxController {
  // List of companies (replace with your actual company model if needed)
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  final List<Company> companies = [];

  // Selected company
  Company? selectedCompany;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  void fetchCompanies() async {
    var response = await crud.get(AppLink.company);
    if (response.statusCode == 200) {
      print(response.body);
      companies.addAll((response.body as List).map((item) => Company.fromJson(item)).toList());
      update();
    } else {
      dialogfun.showSnackError("Error", "Failed to load companies");
    }
  }

  void selectCompany(Company company) {
    Get.toNamed(AppRoute.login, arguments: {'company': company});
  }
}
