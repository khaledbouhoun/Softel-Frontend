import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/data/model/company.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class CompanyController extends GetxController {
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();
  final companies = <Company>[].obs;
  final Rxn<Company> selectedCompany = Rxn<Company>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    isLoading.value = true;
    try {
      final response = await crud.get(AppLink.company);
      if (response.statusCode == 200 && response.body is List) {
        final items = (response.body as List).map((item) => Company.fromJson(item)).toList();
        companies.assignAll(items);
      } else {
        companies.clear();
        dialogfun.showSnackError("Error", "Failed to load companies");
      }
    } catch (e) {
      companies.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCompany(Company company) async {
    selectedCompany.value = company;
    await Get.toNamed(AppRoute.login, arguments: {'company': company});
  }
}

