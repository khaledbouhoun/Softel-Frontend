import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:softel/controller/auth/signup_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/functions/validinput.dart';
import 'package:softel/data/model/communes.dart';
import 'package:softel/data/model/wilayas.dart';
import 'package:softel/view/widget/auth/customtextformauth.dart';
import 'package:softel/view/widget/auth/customtexttitleauth.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignUp extends GetView<SignUpController> {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Form(
          key: controller.formstate,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Backwidget(),
                  CustomTextTitleAuth(text: "signup_title".tr), // "Sign Up"
                  SizedBox(width: Get.width * 0.1),
                ],
              ),
              const SizedBox(height: 100),
              CustomTextFormAuth(
                formstate: controller.formstate,
                isNumber: false,
                valid: (val) {
                  return validInput(val!, 3, 95, "Nom");
                },
                mycontroller: controller.nom,
                iconData: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(AppSvg.profile, color: AppColor.primaryColor),
                ),
                labeltext: "name".tr, // "Nom"Username"
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: Get.height * 0.08,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.centerLeft,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        controller.email.isEmpty ? "email".tr : controller.email, // "Email"
                        style: TextStyle(color: AppColor.secondaryColor, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Cairo"),
                      ),
                    ),
                    SvgPicture.asset(AppSvg.email, color: AppColor.primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              CustomTextFormAuth(
                formstate: controller.formstate,
                max: 10,
                isNumber: true,
                textinputaction: TextInputAction.done,
                valid: (val) {
                  return validInput(val!, 9, 10, "phone");
                },
                mycontroller: controller.phone,
                iconData: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(AppSvg.call, color: AppColor.primaryColor),
                ),
                labeltext: "phone".tr, // "Phone Number"
                textinputtype: TextInputType.number,
              ),
              const SizedBox(height: 15),
              Obx(
                () => Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 65,
                      child: CustomDropdown<Wilayas>.search(
                        overlayHeight: 500,
                        decoration: CustomDropdownDecoration(
                          hintStyle: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
                          closedBorder: Border.all(color: !controller.isWilayaValid.value ? AppColor.warning : AppColor.primaryColor),
                          expandedBorder: Border.all(color: !controller.isWilayaValid.value ? AppColor.warning : AppColor.primaryColor),
                        ),
                        items: controller.wilayas,
                        hintText: 'select_wilaya'.tr,
                        headerBuilder: (context, selectedItem, enabled) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.wilayaSelected.value?.terNom ?? 'select_wilaya'.tr,
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.wilayaSelected.value?.terNo?.toString() ?? '',
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          trailing: Text(
                            item.terNo!.toString(),
                            style: TextStyle(color: AppColor.primaryColor, fontFamily: "Nunito", fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          title: Text(
                            item.terNom!,
                            style: TextStyle(color: AppColor.primaryColor, fontFamily: "Nunito", fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            onItemSelect();
                            controller.selectWilaya(item);
                          },
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Visibility(
                          visible: !controller.isWilayaValid.value,
                          child: Text('please_wilaya'.tr, style: TextStyle(color: AppColor.warning, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              Obx(
                () => Container(
                  alignment: Alignment.topCenter,
                  child: controller.isLoading.value
                      ? Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
                      : Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              height: 65,
                              child: CustomDropdown<Communes>.search(
                                overlayHeight: 500,
                                decoration: CustomDropdownDecoration(
                                  hintStyle: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
                                  closedBorder: Border.all(color: !controller.isCommuneValid.value ? AppColor.warning : AppColor.primaryColor),
                                  expandedBorder: Border.all(color: !controller.isCommuneValid.value ? AppColor.warning : AppColor.primaryColor),
                                ),
                                items: controller.communes,
                                hintBuilder: (context, hint, enabled) => Text(
                                  hint,
                                  style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                hintText: 'select_commune'.tr,
                                headerBuilder: (context, selectedItem, enabled) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.communeSelected.value?.vilNom ?? 'select_commune'.tr,
                                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.communeSelected.value?.vilNo?.toString() ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
                                  titleAlignment: ListTileTitleAlignment.center,
                                  trailing: Text(
                                    item.vilNo!.toString(),
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontFamily: "Nunito",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  title: Text(
                                    item.vilNom!,
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontFamily: "Nunito",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    onItemSelect();
                                    controller.selectCommune(item);
                                  },
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Visibility(
                                  visible: !controller.isCommuneValid.value,
                                  child: Text('please_commune'.tr, style: TextStyle(color: AppColor.warning, fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 100),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: MaterialButton(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  onPressed: controller.validateAndSubmit,
                  color: AppColor.primaryColor,
                  textColor: Colors.white,
                  child: Obx(
                    () => controller.isLoadingbutton.value == false
                        ? Text("signup".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                        : const CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
