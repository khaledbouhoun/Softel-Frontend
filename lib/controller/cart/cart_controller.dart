import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/services/cart_state_service.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class CartController extends GetxController {
  final MyServices myServices = Get.find<MyServices>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  final data = <CartModel>[].obs;
  final RxDouble totalcountproducts = 0.0.obs;
  final RxBool isloading = false.obs;
  final RxBool isloadingConfirmButton = false.obs;

  String totalprice() {
    double total = 0.0;
    for (var element in data) {
      total += (element.cddMontant ?? 0.0);
    }
    return total.toStringAsFixed(2);
  }

  @override
  void onInit() {
    super.onInit();
    view();
  }

  Future<void> view() async {
    isloading.value = true;
    try {
      final response = await crud.get(AppLink.cart);
      if (response.statusCode == 200 && response.body is List) {
        final items = (response.body as List).map((e) => CartModel.fromJson(e)).toList();
        data.assignAll(items);
        Get.find<CartStateService>().updateCartCount(items.length);
      } else if (response.statusCode == 404) {
        data.clear();
        Get.find<CartStateService>().updateCartCount(0);
      } else {
        data.clear();
        dialogfun.showSnackError("Error ${response.statusCode}", response.body?['message']?.toString() ?? '');
      }
    } catch (e) {
      data.clear();
    } finally {
      isloading.value = false;
    }
  }

  Future<void> delete(BuildContext context, CartModel cart) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.delete_forever, color: Colors.red, size: 32),
            const SizedBox(width: 10),
            Text(
              "delete_item".tr,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700]),
            ),
          ],
        ),
        content: Text("are_you_sure_you_want_to_delete_item".tr, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("cancel".tr, style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete, color: Colors.white),
            label: Text("delete".tr, style: const TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (result == true) {
      final response = await crud.delete(AppLink.deleteCart, {"CddID": cart.cddID, "CddArtNo": cart.cddArtNo});
      if (response.statusCode == 200) {
        dialogfun.showSnackSuccess("success".tr, "successfully_deleted".tr);
        await view();
        await Get.find<CartStateService>().fetchCartCount();
      } else {
        dialogfun.showSnackError("${"error".tr} ${response.statusCode}", response.body?['message']?.toString() ?? '');
      }
    }
  }

  Future<void> confirmcommande(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_box, color: Colors.green, size: 32),
            const SizedBox(width: 10),
            Text(
              "confirm".tr,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
          ],
        ),
        content: Text("are_you_sure_you_want_to_confirm_this_order".tr, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("cancel".tr, style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
            label: Text("confirm".tr, style: const TextStyle(color: Colors.white)),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      isloadingConfirmButton.value = true;
      final response = await crud.get(AppLink.confirmCommande);
      if (response.statusCode == 200) {
        isloadingConfirmButton.value = false;
        Get.find<CartStateService>().updateCartCount(0);
        data.clear();
        Get.back();
        dialogfun.showSnackSuccess("success".tr, "item_confirmed_successfully".tr);
      } else {
        isloadingConfirmButton.value = false;
        dialogfun.showSnackError("error".tr, response.body?['message']?.toString() ?? '');
      }
    }
  }

  Future<void> edit(CartModel cart) async {
    final Product product = Product(
      artNo: cart.cddArtNo,
      artNom: cart.cddArtNom,
      artFam: cart.cddArtFam,
      artSFam: cart.cddArtSFam,
      artUni: cart.cddArtUni,
      artColisage: cart.cddColisage,
      artColisageNom: cart.cddColisageNom,
      artPrix: cart.cddPrix,
      artUntCol: cart.cddUntCol,
      artQte: cart.cddQte,
      artImages: cart.cddImages,
    );

    final bool? result = await Get.toNamed<bool?>(AppRoute.productdetails, arguments: {"product": product, "fromcart": true});
    if (result == true) {
      await view();
    }
  }
}
