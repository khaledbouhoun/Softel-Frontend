import 'package:softel/controller/traking/traking_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/constant/imageasset.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/view/widget/backwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:softel/view/widget/loadingwidget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Traking extends StatelessWidget {
  const Traking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Text(
          "my_orders".tr,
          style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 24),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
      ),
      backgroundColor: AppColor.background,
      body: GetBuilder<TrakingController>(
        init: TrakingController(),
        builder: (controller) {
          if (controller.isloading.value) {
            return Center(child: Loadingwidget(width: Get.width / 2));
          } else {
            if (controller.commands.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                      child: SvgPicture.asset(AppSvg.truck, width: 80, height: 80, color: AppColor.primaryColor.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "no_orders".tr,
                      style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                  ],
                ),
              );
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: controller.commands.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Get.toNamed(AppRoute.trakingdetails, arguments: {"Command": controller.commands[index]});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    controller.commands[index].cdeStatus == 1
                                        ? AppSvg.check
                                        : controller.commands[index].cdeStatus == 2
                                        ? AppSvg.time
                                        : AppSvg.truck,
                                    width: 30,
                                    height: 30,
                                    color: controller.statusColor(controller.commands[index].cdeStatus!),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "# ${controller.commands[index].cdeID}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: controller.statusColor(controller.commands[index].cdeStatus!),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: controller.statusColor(controller.commands[index].cdeStatus!),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            controller.commands[index].cdeStatus == 1
                                                ? "orderstep_1".tr
                                                : controller.commands[index].cdeStatus == 2
                                                ? "orderstep_2".tr
                                                : "orderstep_3".tr,
                                            style: TextStyle(
                                              color: controller.statusColor(controller.commands[index].cdeStatus!),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Get.toNamed(AppRoute.trakingcartdetaills, arguments: {"Command": controller.commands[index]});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.statusColor(controller.commands[index].cdeStatus!).withOpacity(0.05),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'order_number'.tr} ${index + 1}',
                                  style: TextStyle(
                                    color: controller.statusColor(controller.commands[index].cdeStatus!),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "details".tr,
                                      style: TextStyle(
                                        color: controller.statusColor(controller.commands[index].cdeStatus!),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: controller.statusColor(controller.commands[index].cdeStatus!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TrakingDetails extends StatelessWidget {
  const TrakingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "traking".tr,
          style: TextStyle(color: AppColor.primaryColor, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        leading: Backwidget(),
      ),
      body: GetBuilder<TrakingControllerDetails>(
        init: TrakingControllerDetails(),
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: controller.trackingSteps.length,
                    itemBuilder: (context, index) {
                      final step = controller.trackingSteps[index];
                      final stepbefor = controller.trackingSteps[(index - 1) < 0 ? 0 : (index - 1)];
                      final isFirst = index == 0;
                      final isLast = index == controller.trackingSteps.length - 1;

                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.2,
                        isFirst: isFirst,
                        isLast: isLast,
                        beforeLineStyle: LineStyle(
                          color: stepbefor.isCompleted ? AppColor.primaryColor : Colors.grey.shade200,
                          thickness: 3,
                        ),
                        afterLineStyle: LineStyle(color: step.isCompleted ? AppColor.primaryColor : Colors.grey.shade200, thickness: 3),
                        indicatorStyle: IndicatorStyle(
                          width: 35,
                          height: 35,
                          indicator: Container(
                            decoration: BoxDecoration(
                              boxShadow: step.isCurrent
                                  ? [BoxShadow(blurRadius: 15, spreadRadius: 5, color: AppColor.primaryColor.withOpacity(0.2))]
                                  : [],
                              shape: BoxShape.circle,
                              color: step.isCompleted || step.isCurrent ? AppColor.primaryColor : Colors.white,
                              border: Border.all(
                                color: step.isCompleted || step.isCurrent ? AppColor.primaryColor : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                step.isCompleted ? AppSvg.check : (step.isCurrent ? AppSvg.truck : AppSvg.circle),
                                color: step.isCompleted || step.isCurrent ? Colors.white : Colors.grey.shade300,
                                width: 20,
                                height: 20,
                              ),
                              // child: Icon(
                              //   step.isCompleted ? Icons.check_rounded : (step.isCurrent ? Icons.local_shipping_rounded : Icons.circle),
                              //   color: step.isCompleted || step.isCurrent ? Colors.white : Colors.grey.shade300,
                              //   size: step.isCompleted ? 20 : 18,
                              // ),
                            ),
                          ),
                        ),
                        endChild: Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 30),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: step.isCompleted || step.isCurrent ? step.color!.withOpacity(0.05) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: step.isCompleted || step.isCurrent ? step.color!.withOpacity(0.2) : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: step.isCompleted || step.isCurrent ? step.color! : Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: step.isCompleted || step.isCurrent ? step.color!.withOpacity(0.7) : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
