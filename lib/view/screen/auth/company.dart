import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/controller/auth/company_controller.dart';
import 'package:softel/view/widget/auth/companywidget.dart';
import 'package:softel/view/widget/loadingwidget.dart';

class CompanyPage extends GetView<CompanyController> {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'select_company'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchCompanies,
        child: Obx(
          () {
            if (controller.isLoading.value && controller.companies.isEmpty) {
              return Center(child: Loadingwidget(width: Get.width / 2));
            }

            if (controller.companies.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: Get.height * 0.3),
                  Center(
                    child: Text('no_companies_found'.tr, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              itemCount: controller.companies.length,
              itemBuilder: (context, index) {
                return CompanyWidget(
                  company: controller.companies[index],
                  ontap: () async {
                    await controller.selectCompany(controller.companies[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}