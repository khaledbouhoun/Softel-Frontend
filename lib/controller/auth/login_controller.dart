import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:softel/controller/auth/company_controller.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/view/widget/dialog.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/data/model/company.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final CompanyController companyController = Get.find<CompanyController>();
  final MyServices myServices = Get.find();

  String? googleId;
  String? email;
  String? name;
  String? photoUrl;
  Company? company;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    print('LoginController initialized ......');
    company = companyController.selectedCompany;
    print('LoginController initialized with company: ${company?.clsNom}');
  }

  final GoogleSignIn signIn = GoogleSignIn();

  /// Sign in with Google and save user info locally.
  Future<void> loginWithGoogle() async {
    try {
      GoogleSignInAccount? user = await signIn.signIn();
      if (user == null) {
        dialogfun.showSnackError('login_cancelled'.tr, 'google_signin_cancelled'.tr);
        return;
      }

      googleId = user.id;
      name = user.displayName;
      email = user.email;
      photoUrl = user.photoUrl;

      myServices.sharedPreferences.setString('CliGoogleId', googleId ?? '');
      myServices.sharedPreferences.setString('google_id', googleId ?? '');
      myServices.sharedPreferences.setString('name', name ?? '');
      myServices.sharedPreferences.setString('email', email ?? '');
      myServices.sharedPreferences.setString('photoUrl', photoUrl ?? '');

      // Optionally, proceed to backend login after Google sign-in
      await login();
    } catch (e) {
      dialogfun.showSnackError('error'.tr, "❌ Google Sign-In failed: $e");
      print("❌ Google Sign-In failed: $e");
    }
  }

  /// Sign out from Google and clear local user info.
 

  /// Login to backend using Google ID.
  Future<void> login() async {
    try {
      isLoading = true;
      update();

      final response = await crud.post(AppLink.login, {
        'ClsNo': company?.clsNo,
        'CliGoogleId': myServices.sharedPreferences.getString('CliGoogleId') ?? '',
      });
      print("Response from backend login: ${response.body}");
      print("Response from backend login: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = response.body as Map<String, dynamic>;
        if (body.containsKey('token')) {
          await _secureStorage.write(key: 'token', value: body['token']);
        }
        if (body.containsKey('client')) {
          final client = body['client'];
          if (client is Map<String, dynamic>) {
            myServices.sharedPreferences.setString('name', client['name'] ?? '');
            myServices.sharedPreferences.setString('email', client['email'] ?? '');
          }
        }
        print("✅ Backend login successful for Google ID: $googleId");
        print("data arguments: company=${company?.clsNom}, googleId=$googleId, name=$name, email=$email");
        Get.offAllNamed(AppRoute.homepage);
      } else if (response.statusCode == 401) {
        dialogfun.showSuccessDialog(
          'you_already_signup_before'.tr,
          "${'success_signup_text1'.tr} ${company?.clsNom ?? ""} ${'success_signup_text2'.tr}",
          null,
        );
      } else if (response.statusCode == 404) {
        Get.toNamed(AppRoute.signUp, arguments: {'company': company, 'googleId': googleId, 'nom': name, 'email': email});
      } else {
        dialogfun.showSnackError('error_failed'.tr, 'error_google_signin'.tr);
      }
    } catch (e) {
      dialogfun.showSnackError('error'.tr, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
