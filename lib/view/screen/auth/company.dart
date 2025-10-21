import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/controller/auth/company_controller.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/view/widget/auth/companywidget.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('select_company'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColor.background,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 80,
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<CompanyController>(
        init: CompanyController(),
        builder: (controller) {
          if (controller.companies.isEmpty) {
            return Center(child: Loadingwidget(width: Get.width / 2));
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Slightly taller for name visibility
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.companies.length,
              itemBuilder: (context, index) {
                return CompanyWidget(
                  company: controller.companies[index],
                  ontap: () {
                    controller.selectCompany(controller.companies[index]);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
