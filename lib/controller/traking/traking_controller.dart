import 'dart:ui';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/command.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class TrakingController extends GetxController {
  MyServices myServices = Get.find();
  Dialogfun dialogfun = Dialogfun();
  RxBool isloading = false.obs;
  Crud crud = Crud();
  late String? userid;
  List<Command> commands = [];

  Color statusColor(int statue) {
    switch (statue) {
      case 1:
        return AppColor.trakingColor1;
      case 2:
        return AppColor.trakingColor2;
      case 3:
        return AppColor.trakingColor4;
      default:
        return Colors.grey;
    }
  }

  Future<void> fetch() async {
    isloading.value = true;
    var response = await crud.get(AppLink.commandes);
    if (response.statusCode == 200) {
      isloading.value = false;
      commands = (response.body as List).map((e) => Command.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      isloading.value = false;
      commands = [];
    } else {
      isloading.value = false;
      commands = [];
      dialogfun.showSnackError("Error", "Failed to fetch commands");
    }
    update();
  }

  @override
  void onInit() {
    fetch();
    super.onInit();
  }
}

class TrakingControllerDetails extends GetxController {
  MyServices myServices = Get.find();
  Dialogfun dialogfun = Dialogfun();
  Crud crud = Crud();

  String language = 'fr';
  int currentStep = 1;
  Command? command;

  List<TrackingStep> trackingSteps = [];

  List<TrackingStep> trackingStepscash = [
    TrackingStep(id: 1, title: "order_confirmed_title".tr, subtitle: "order_confirmed_subtitle".tr, color: AppColor.trakingColor1),
    TrackingStep(id: 2, title: "order_preparing_title".tr, subtitle: "order_preparing_subtitle".tr, color: AppColor.trakingColor2),
    TrackingStep(id: 3, title: "order_delivered_title".tr, subtitle: "order_delivered_subtitle".tr, color: AppColor.trakingColor4),
  ];

  @override
  void onInit() {
    // Use 1 as default if arguments are missing or 'currentStep' is not provided

    language = myServices.sharedPreferences.getString("lang") ?? 'fr';
    command = Get.arguments['Command'];
    currentStep = command?.cdeStatus ?? 1;

    switch (currentStep) {
      case 1:
        trackingStepscash[0].isCurrent = true;
        break;
      case 2:
        trackingStepscash[0].isCompleted = true;
        trackingStepscash[1].isCurrent = true;
        break;
      case 3:
        trackingStepscash[0].isCompleted = true;
        trackingStepscash[1].isCompleted = true;
        trackingStepscash[2].isCurrent = true;
        break;
      default:
        break;
    }
    trackingSteps = trackingStepscash;
    super.onInit();
  }
}

class TrackingStep {
  final int id;
  final String title;
  final String subtitle;
  final Color? color;
  bool isCompleted;
  bool isCurrent;

  TrackingStep({
    required this.id,
    required this.title,
    required this.subtitle,
    this.color,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}
