import 'package:flutter/material.dart';
import 'package:softel/controller/home/home_controller.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/product.dart';
import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/screen/product/productdetails.dart';
import 'package:softel/view/widget/dialog.dart';

class CartController extends GetxController {
  MyServices myServices = Get.find();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  List<CartModel> data = [];
  RxDouble totalcountproducts = 0.0.obs;
  RxBool isloading = false.obs;
  RxBool isloadingConfirmButton = false.obs;

  String totalprice() {
    double total = 0.0;
    for (var element in data) {
      total += (element.cddMontant ?? 0.0);
    }
    return total.toStringAsFixed(2);
  }

  Future<void> view() async {
    isloading.value = true;
    print("Fetching cart items...");
    var response = await crud.get(AppLink.cart);
    if (response.statusCode == 200) {
      isloading.value = false;
      data = (response.body as List).map((e) => CartModel.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      isloading.value = false;
      data = [];
    } else {
      isloading.value = false;
      dialogfun.showSnackError("Error ${response.statusCode}", response.body['message']);
      data = [];
    }
    update();
  }

  Future<void> delete(BuildContext context, CartModel cart) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red, size: 32),
            SizedBox(width: 10),
            Text(
              "delete_item".tr,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700]),
            ),
          ],
        ),
        content: Text("are_you_sure_you_want_to_delete_item".tr, style: TextStyle(fontSize: 16)),
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
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text("delete".tr, style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (result == true) {
      var response = await crud.delete(AppLink.deleteCart, {"CddID": cart.cddID, "CddArtNo": cart.cddArtNo});
      if (response.statusCode == 200) {
        dialogfun.showSnackSuccess("success".tr, "successfully_deleted".tr);
        view();
      } else {
        dialogfun.showSnackError("${"error".tr} ${response.statusCode}", response.body['message']);
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
            Icon(Icons.check_box, color: Colors.green, size: 32),

            SizedBox(width: 10),
            Text(
              "confirm".tr,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
            ),
          ],
        ),
        content: Text("are_you_sure_you_want_to_confirm_this_order".tr, style: TextStyle(fontSize: 16)),
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
            icon: Icon(Icons.check, color: Colors.white),
            label: Text("confirm".tr, style: TextStyle(color: Colors.white)),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    if (result == true) {
      isloadingConfirmButton.value = true;
      var response = await crud.get(AppLink.confirmCommande);
      if (response.statusCode == 200) {
        isloadingConfirmButton.value = false;
        await Get.find<HomeController>().fetchAll();
        Get.back();
        dialogfun.showSnackSuccess("success".tr, "item_confirmed_successfully".tr);
      } else {
        isloadingConfirmButton.value = false;
        dialogfun.showSnackError("error".tr, response.body['message']);
      }
    }
  }

  Future<void> edit(CartModel cart) async {
    Product product = Product(
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
    );

    final bool? result = await Get.to<bool?>(() => ProductDetails(), arguments: {"product": product, "fromcart": true});
    if (result == true) {
      view();
    }
  }

  Future<Product?> getdartbyid(int productsid) async {
    return null;
  }

  @override
  void onInit() {
    view();
    super.onInit();
  }
}
