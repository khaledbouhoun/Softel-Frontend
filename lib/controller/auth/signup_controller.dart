import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/communes.dart';
import 'package:softel/data/model/company.dart';
import 'package:softel/data/model/wilayas.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  // FirebaseAuth auth = FirebaseAuth.instance;

  late TextEditingController nom;
  late Company company;
  late String idGoogle;
  late String email;
  TextEditingController phone = TextEditingController();
  List<Wilayas> wilayas = [];
  List<Communes> communes = [];
  Wilayas? wilayaSelected;
  Communes? communeSelected;
  bool isWilayaValid = true;
  bool isCommuneValid = true;

  RxBool isLoading = false.obs;
  RxBool isLoadingbutton = false.obs;

  String otpCodeSend = "";
  MyServices myServices = Get.find();
  bool isshowpassword = false;
  void showPassword() {
    isshowpassword = !isshowpassword;
    update();
  }

  @override
  void onInit() {
    idGoogle = Get.arguments['idGoogle'] ?? '';
    company = Get.arguments['company'] ?? Company();
    nom = Get.arguments['nom'] != null ? TextEditingController(text: Get.arguments['nom']) : TextEditingController();
    email = Get.arguments['email'] ?? '';
    getWilayas();

    super.onInit();
  }

  @override
  void dispose() {
    nom.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> getWilayas() async {
    isLoading.value = true;
    var response = await crud.get(AppLink.wilayas);
    if (response.statusCode == 200) {
      wilayas = (response.body as List).map((item) => Wilayas.fromJson(item)).toList();
    } else {
      dialogfun.showSnackError("error".tr, "failedwilayas".tr);
    }
    isLoading.value = false;
    update();
  }

  Future<void> getCommunes(String wilayaId) async {
    isLoading.value = true;
    var response = await crud.get('${AppLink.communes}/$wilayaId');
    print("Response from getCommunes: ${response.body}");
    print("Response from getCommunes: ${response.statusCode}");

    if (response.statusCode == 200) {
      communes = (response.body as List).map((item) => Communes.fromJson(item)).toList();
    } else {
      dialogfun.showSnackError("error".tr, "failedcommunes".tr);
    }
    isLoading.value = false;
    update();
  }

  Future<void> signUp() async {
    isLoadingbutton.value = true;
    print("Signing up with id: $idGoogle, nom: ${nom.text}, email: $email, phone: ${phone.text}");
    try {
      var response = await crud.post(AppLink.signUp, {
        "CliCls": company.clsNo,
        "CliNom": nom.text,
        "CliEmail": email,
        "CliTel": phone.text,
        "CliWilaya": wilayaSelected?.terNom,
        "CliCommune": communeSelected?.vilNom,
        "CliGoogleId": idGoogle,
      });
      print("Response from signup: ${response.body}");
      print("Response from signup: ${response.statusCode}");
      if (response.statusCode == 422) {
        isLoadingbutton.value = false;
        String errorMsg = '';
        Map<String, dynamic> errors = response.body['errors'];
        errors.forEach((key, value) {
          errorMsg += '${value.join(', ')}\n';
        });
        dialogfun.showSnackError("error_failed".tr, errorMsg);
      } else if (response.statusCode == 200) {
        isLoadingbutton.value = false;
        dialogfun.showSuccessDialog('success_signup'.tr, "${'success_signup_text1'.tr} ${company.clsNom} ${'success_signup_text2'.tr}", () {
          Get.back();
        });
      }
    } catch (e) {
      dialogfun.showErrorDialog("error_failed".tr, e.toString(), () {
        Get.back();
      });
    }
  }
}
