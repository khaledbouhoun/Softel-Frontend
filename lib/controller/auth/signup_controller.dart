import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/communes.dart';
import 'package:softel/data/model/company.dart';
import 'package:softel/data/model/wilayas.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();
  final MyServices myServices = Get.find<MyServices>();

  late TextEditingController nom;
  late Company company;
  late String idGoogle;
  late String email;
  final TextEditingController phone = TextEditingController();

  final RxList<Wilayas> wilayas = <Wilayas>[].obs;
  final RxList<Communes> communes = <Communes>[].obs;
  final Rxn<Wilayas> wilayaSelected = Rxn<Wilayas>();
  final Rxn<Communes> communeSelected = Rxn<Communes>();
  final RxBool isWilayaValid = true.obs;
  final RxBool isCommuneValid = true.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingbutton = false.obs;
  final RxBool isshowpassword = false.obs;

  String otpCodeSend = "";

  void showPassword() {
    isshowpassword.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      idGoogle = args['googleId']?.toString() ?? '';
      if (args['company'] is Company) {
        company = args['company'] as Company;
      } else {
        company = Company();
      }
      nom = TextEditingController(text: args['nom']?.toString() ?? '');
      email = args['email']?.toString() ?? '';
    } else {
      idGoogle = '';
      company = Company();
      nom = TextEditingController();
      email = '';
    }
    getWilayas();
  }

  @override
  void onClose() {
    nom.dispose();
    phone.dispose();
    super.onClose();
  }

  Future<void> getWilayas() async {
    isLoading.value = true;
    try {
      final response = await crud.get(AppLink.wilayas);
      if (response.statusCode == 200) {
        wilayas.assignAll((response.body as List).map((item) => Wilayas.fromJson(item)).toList());
      } else {
        dialogfun.showSnackError("error".tr, "failedwilayas".tr);
      }
    } catch (e) {
      dialogfun.showSnackError("error".tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCommunes(String wilayaId) async {
    isLoading.value = true;
    try {
      final response = await crud.get('${AppLink.communes}/$wilayaId');
      if (response.statusCode == 200) {
        communes.assignAll((response.body as List).map((item) => Communes.fromJson(item)).toList());
      } else {
        dialogfun.showSnackError("error".tr, "failedcommunes".tr);
      }
    } catch (e) {
      dialogfun.showSnackError("error".tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectWilaya(Wilayas item) {
    wilayaSelected.value = item;
    communeSelected.value = null;
    communes.clear();
    isWilayaValid.value = true;
    isCommuneValid.value = true;
    if (item.terNo != null) {
      getCommunes(item.terNo!);
    }
  }

  void selectCommune(Communes item) {
    communeSelected.value = item;
    isCommuneValid.value = true;
  }

  void validateAndSubmit() {
    isWilayaValid.value = wilayaSelected.value != null;
    isCommuneValid.value = communeSelected.value != null;

    if (formstate.currentState!.validate() && isWilayaValid.value && isCommuneValid.value) {
      signUp();
    }
  }

  Future<void> signUp() async {
    isLoadingbutton.value = true;
    try {
      final response = await crud.post(AppLink.signUp, {
        "CliCls": company.clsNo,
        "CliNom": nom.text,
        "CliEmail": email,
        "CliTel": phone.text,
        "CliWilaya": wilayaSelected.value?.terNom,
        "CliCommune": communeSelected.value?.vilNom,
        "CliGoogleId": idGoogle,
      });

      if (response.statusCode == 422) {
        String errorMsg = '';
        final errors = response.body['errors'];
        if (errors is Map) {
          errors.forEach((key, value) {
            if (value is List) {
              errorMsg += '${value.join(', ')}\n';
            } else {
              errorMsg += '$value\n';
            }
          });
        }
        dialogfun.showSnackError("error_failed".tr, errorMsg);
      } else if (response.statusCode == 201) {
        dialogfun.showSuccessDialog(
          'success_signup'.tr,
          "${'success_signup_text1'.tr} ${company.clsNom ?? ''} ${'success_signup_text2'.tr}",
          () => Get.back(),
        );
      }
    } catch (e) {
      dialogfun.showErrorDialog("error_failed".tr, e.toString(), () => Get.back());
    } finally {
      isLoadingbutton.value = false;
    }
  }
}
