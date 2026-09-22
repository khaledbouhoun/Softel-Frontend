import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/services.dart';
import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class SettingsController extends GetxController {
  final MyServices myServices = Get.find<MyServices>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  final RxString nom = ''.obs;
  final RxString photoUrl = ''.obs;
  final RxString companyNom = ''.obs;
  final RxString facebook = ''.obs;
  final RxString instagram = ''.obs;
  final RxString tiktok = ''.obs;
  final RxString whatsapp = ''.obs;
  final GoogleSignIn signIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    nom.value = myServices.sharedPreferences.getString("name") ?? '';
    photoUrl.value = myServices.sharedPreferences.getString("photoUrl") ?? '';
    companyNom.value = myServices.sharedPreferences.getString("companynom") ?? '';
    facebook.value = myServices.sharedPreferences.getString("facebook") ?? '';
    instagram.value = myServices.sharedPreferences.getString("instagram") ?? '';
    tiktok.value = myServices.sharedPreferences.getString("tiktok") ?? '';
    whatsapp.value = myServices.sharedPreferences.getString("whatsapp") ?? '';
  }

  Future<void> signOutGoogle() async {
    try {
      await signIn.disconnect();
    } catch (e) {
      // Ignore sign-out errors
    }
    myServices.sharedPreferences.remove('google_id');
    myServices.sharedPreferences.remove('CliGoogleId');
    myServices.sharedPreferences.remove('email');
    myServices.sharedPreferences.remove('name');
    myServices.sharedPreferences.remove('photoUrl');
  }

  Future<void> logout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                child: const Icon(Icons.logout, color: Colors.red, size: 36),
              ),
              const SizedBox(height: 18),
              Text(
                "Logout",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red[700]),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      await signOutGoogle();
                      await Get.offAllNamed("/");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.red[600]),
                const SizedBox(width: 18),
                const Text("Logging out...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );

      // Preserve onboarding and language settings
      String? languageSelected = myServices.sharedPreferences.getString("language_selected");
      // Clear all preferences
      myServices.sharedPreferences.clear();

      if (languageSelected == "true") {
        myServices.sharedPreferences.setString("language_selected", "true");
      }

      // Set step to login
      myServices.sharedPreferences.setString("step", "login");
      var response = await crud.delete(AppLink.logout, {});
      Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
      if (response.statusCode == 200) {
        dialogfun.showSnackSuccess("success".tr, "successfully_logged_out".tr);
        Get.offAllNamed(AppRoute.login);
      } else {
        dialogfun.showSnackError("error".tr, "something_went_wrong".tr);
      }
    }
  }
}
