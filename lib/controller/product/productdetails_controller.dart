import 'package:softel/controller/cart/cart_controller.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/product.dart';
import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class ProductDetailsController extends GetxController {
  MyServices myServices = Get.find();
  CartController cartController = Get.put(CartController());

  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  late Product product;
  bool isUnitSelected = true;
  bool confirm = false;
  RxDouble totalprice = 0.0.obs;
  RxDouble qtyinput = 0.0.obs;
  RxDouble coulis = 0.0.obs;
  RxDouble unites = 0.0.obs;
  bool fromcart = false;
  RxBool isloading = false.obs;
  late String usersid;
  @override
  void onInit() {
    intialData();
    super.onInit();
  }

  Future<void> intialData() async {
    usersid = myServices.sharedPreferences.getString("id").toString();
    product = Get.arguments['product'] as Product;
    print("productno: ${product.artNo}");
    print("productnom: ${product.artNom}");
    print("productfam: ${product.artFam}");
    print("productsfam: ${product.artSFam}");
    print("productcddColisage: ${product.artColisage}");
    print("productcddColisage: ${product.artColisageNom}");
    print("productsuni: ${product.artUni}");
    print("productartUntCol: ${product.artUntCol}");
    print("productartPrix: ${product.artPrix}");
    print("productqte: ${product.artQte}");

    fromcart = Get.arguments['fromcart'] as bool;
    qtyinput.value = product.artQte ?? 0.0;
    calculate();

    update();
  }

  Future<void> storeCommand() async {
    isloading.value = true;
    print("product: ${product.artNo}");
    var data = {
      "CddArt": product.artNo,
      "CddColisage": "01",
      "CddColis": (product.artColisageNom ?? '').isNotEmpty ? (isUnitSelected ? coulis.value : qtyinput.value) : 0,
      "CddUntCol": (product.artColisageNom ?? '').isNotEmpty ? (product.artUntCol ?? 0) : 0,
      "CddQte": isUnitSelected ? qtyinput.value : unites.value,
      "CddPrix": product.artPrix ?? 0,
      "CddMontant": totalprice.value,
    };
    print("data: $data");
    var response = await crud.post(AppLink.storeProduct, data);
    print('Response: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 201) {
      isloading.value = false;
      if (fromcart) {
        Get.back(result: true);
      } else {
        Get.back(result: isUnitSelected ? qtyinput.value : unites.value);
      }
      dialogfun.showSnackSuccess("success".tr, "successfully_added".tr);
    } else if (response.statusCode == 422) {
      isloading.value = false;
      String errorMsg = '';
      Map<String, dynamic> errors = response.body['errors'];
      errors.forEach((key, value) {
        errorMsg += '${value.join(', ')}\n';
      });
      dialogfun.showSnackError("something_went_wrong".tr, errorMsg);
    } else {
      isloading.value = false;
      dialogfun.showSnackError("error".tr, "something_went_wrong".tr);
    }
  }

  Future<void> deletefromcart() async {
    isloading.value = true;

    cartController.view();
    CartModel cart = cartController.data.firstWhere((c) => c.cddArtNo == product.artNo);
    var response = await crud.delete(AppLink.deleteCart, {"CddID": cart.cddID, "CddArtNo": cart.cddArtNo});
    if (response.statusCode == 200) {
      isloading.value = false;
      if (fromcart) {
        Get.back(result: true);
      } else {
        Get.back(result: isUnitSelected ? qtyinput.value : unites.value);
      }
      dialogfun.showSnackSuccess("success".tr, "successfully_removed".tr);
    } else {
      isloading.value = false;
      dialogfun.showSnackError("error".tr, response.body['message']);
    }
  }

  void toggleUnitType(int index) {
    isUnitSelected = index == 0;
    if (isUnitSelected) {
      coulis.value = qtyinput.value;
      qtyinput.value = unites.value;
      unites.value = 0.0;
      totalprice.value = qtyinput.value * (product.artPrix ?? 0);
    } else {
      qtyinput.value = coulis.value;
      unites.value = (product.artUntCol ?? 0) > 1 ? qtyinput.value * (product.artUntCol ?? 0) : unites.value;
      totalprice.value = unites.value * (product.artPrix ?? 0);
    }
    // qtyinput.value = 0.0;
    // totalprice.value = 0.0;
    // unites.value = 0.0;
    // coulis.value = 0.0;
    update();
  }

  void calculate() {
    if ((product.artColisageNom ?? '').isNotEmpty) {
      coulis.value = (product.artUntCol ?? 1) != 0 ? (qtyinput.value ~/ (product.artUntCol ?? 1)).toDouble() : 0.0;
      if (isUnitSelected) {
        unites.value = (product.artUntCol ?? 1) != 0 ? qtyinput.value % (product.artUntCol ?? 1) : 0.0;
      } else {
        unites.value = qtyinput.value * (product.artUntCol ?? 0);
      }
    }

    if (isUnitSelected) {
      totalprice.value = qtyinput.value * (product.artPrix ?? 0);
    } else {
      totalprice.value = unites.value * (product.artPrix ?? 0);
    }
  }

  // --- Quantity Increment/Decrement ---
  void incrementQty() {
    qtyinput.value++;
    calculate();
  }

  void decrementQty() {
    if (qtyinput.value > 0) {
      qtyinput.value--;
    }
    calculate();
  }

  void decrementQtyHold() {
    if (qtyinput.value > 0) {
      qtyinput.value = 1;
      totalprice.value = qtyinput.value * (product.artPrix ?? 0);
      if ((product.artColisageNom ?? '').isNotEmpty) {
        coulis.value = (product.artUntCol ?? 1) != 0 ? (qtyinput.value ~/ (product.artUntCol ?? 1)).toDouble() : 0.0;
        unites.value = (product.artUntCol ?? 1) != 0 ? qtyinput.value % (product.artUntCol ?? 1) : 0.0;
      }
    }
    print("totalprice: ${totalprice.value}");
  }
}
